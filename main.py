import json

# Read maas2.json file
f = open('maas2.json', 'r')
data = json.load(f)
f.close()

highest_sol = 0
highest_sol_data = {}
for sol in data["soles"]:
    sol_num = int(sol["sol"])

    sol.update({"unitOfMeasure": "Celsius", "TZ_Data": "America/Port_of_Spain"})

    if sol_num > highest_sol:
        highest_sol = sol_num
        highest_sol_data = sol

    f = open(f"./dist/{sol_num}", "w")
    f.write(json.dumps(sol))
    f.close()

f = open(f"./dist/index.html", "w")
f.write(json.dumps(highest_sol_data))
f.close()

print("Done")