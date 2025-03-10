import json
import time
import re
import math
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def get_plan(text):
	j = json.loads(text)
	return j[0][0][0]

def fmt(num):
	e = 0
	if(num < 0.1):
		num_e = math.floor(math.log10(num))
		e = (num_e // 3) * 3
	if(e == 0):
		return f"{num:.3f}".rstrip("0").rstrip(".")
	else:
		num /= 10 ** e
		return f"{num:.3f}".rstrip("0").rstrip(".") + f"e{e}"

sns.set_context("talk")
sns.set_palette("viridis")
sns.set_theme(style = "whitegrid")

case_names = [
	"cross_answer",
	"last_interactions"
]
variants = [
	"cte",
	"subq",
	"view",
	"mat_view",
	# "temp_table",
]
cases = []
for v in variants:
	for n in case_names:
		c = v + "_case_" + n
		# if c == "temp_table_case_last_interactions":
		# 	c = "temp_table_case_last_interaction"
		cases.append(c)

cases.append("strings")
cases.append("non-id")

csv = pd.read_csv("../results_hot.csv")
all = pd.DataFrame()

for c in cases:
	df = csv.loc[csv["label"] == c + ".sql", ["label", "query", "result_set", "exec_time", "groups"]]

	df["plan"] = df["result_set"].apply(get_plan)
	f = open(c + ".json", "wt")
	f.write(json.dumps(df["plan"].iloc[0], indent=2))
	f.close()

	df["exec_time"] = df["exec_time"].apply(lambda x: x / 1e6)
	df["total_cost"] = df["plan"].apply(lambda x: x["Plan"]["Total Cost"])
	df["time_per_cost"] = df["exec_time"] / df["total_cost"]

	all = pd.concat([all, df])

copy = ["label", "query", "result_set", "exec_time", "plan", "total_cost", "time_per_cost", "groups"]
cases = {
	"last_interactions": all.loc[all["label"].str.contains("last_inter"), copy],
	"cross_answer": all.loc[all["label"].str.contains("cross_ans"), copy],
	"string_redundancy": all.loc[all["groups"].str.contains("string_id_"), copy]
}

plots = {
	"exec_time": ("Runtime (in ms)", "linear", "log"),
	"total_cost": ("Total Cost", "log", "linear"),
	"time_per_cost": ("Time (in ms) per Cost", "log", "log")
}
for k in cases.keys():
	c = cases[k]
	c["label"] = c["label"] \
		.apply(lambda x: x \
			.split("_case_")[0] \
			.replace("non-id.sql", "base (non-id)") \
			.replace(".sql", "")
		)

	for pk in plots:
		p = sns.barplot(
			data = c,
			x = "label",
			y = pk,
		)

		p.bar_label(p.containers[0], label_type = "center", fmt = fmt, color = "white")

		p.set(
			title = "",
			xlabel = "Query Name",
			ylabel = plots[pk][0],
		)

		pscale = plots[pk][1]

		if k == "string_redundancy":
			pscale = plots[pk][2]

		plt.yscale(pscale)

		if(pscale == "log"):
			max = c[pk].max()
			min = c[pk].min()
			upper = 10 ** math.ceil(math.log10(max))
			lower = 10 ** math.floor(math.log10(min))
			p.set_ylim(bottom = lower, top = upper)
		else:
			p.set_ylim(bottom = 0)

		p.get_figure().set_size_inches(6, 6)
		if k == "string_redundancy":
			p.get_figure().set_size_inches(4, 6)
		p.get_figure().tight_layout()

		plt.savefig(k + "_" + pk + ".png", dpi=600)
		plt.close()
