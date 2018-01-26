
	
roots = {}
employee_dict = {}
employees_months = {}


class Employee:
	def __init__(self, name):
		self.name = name
		self.subordinates = []


def set_roots(employee_dict, boss, month, level):
	if (boss == None):
		return
	#for i in range(level):
	#	print(" ", end='')
	#print(getattr(boss, 'role', ""), "\t", boss.name)
	if (len(boss.subordinates) < 1):
		return
	boss.subordinates = list(map(lambda x: employee_dict[month][x], boss.subordinates))
	for sub in boss.subordinates:
		set_roots(employee_dict, sub, month, level + 1)


def parse_data(data):
	for record_string in data:
		record = record_string.split(",")
		if (len(record) < 6):
			print(record)
			continue
		month = record[0]
		
		if (month not in employee_dict):
			employee_dict[month] = {}
			
		employee_name = record[1]
		if (employee_name not in employees_months):
			employees_months[employee_name] = [month]
		else:
			employees_months[employee_name].append(month)
		
		if (employee_name not in employee_dict[month]):
			employee = Employee(employee_name)
		else:
			employee = employee_dict[month][employee_name]
		employee.user_id = record[2]
		employee.email = record[3]
		employee.role = record[4]
		employee.supervisor = record[5]
		
		supervisor = record[5]
		
		if (supervisor not in employee_dict[month]):
			employee_dict[month][supervisor] = Employee(supervisor)
		
		employee_dict[month][supervisor].subordinates.append(employee_name)
		employee_dict[month][employee_name] = employee
	
	
	for month in employee_dict:
		#print(month)
		boss = employee_dict[month][""]
		roots[month] = boss
		set_roots(employee_dict, boss, month, 0)
	
	
	
def print_employees_for_month(boss, level = 0):
	for i in range(level):
		print("  ", end='')
	print(("%d. %s: %s") % (level, getattr(boss, 'role', ''), boss.name))
	for sub in boss.subordinates:
		print_employees_for_month(sub, level + 1)
		
	

def find_employee(employee_name, root = None):
	if (root == None):
		root = roots["05/01/2017"]
	if root.name == employee_name:
		print("Found")
		print(root.name + ",", root.role)
		print("Immediate Subordinates:", len(root.subordinates))
		for sub in root.subordinates:
			print('\t', sub.name)
		print("Superiors:")
		return True
	else:
		status = False
		for sub in root.subordinates:
			if (find_employee(employee_name, sub)):
				status = True
		if status:
			print('\t', root.name)
			return True



def find_fired_employees():
	print("Fired Employees:")
	print("Months Worked\tLast Month\t\t\tName\t\tSupervisor")
	i = 1
	fired_ids = ""
	fired_emails = ""
	for e in employees_months:
		if (len(employees_months[e]) < 7):
			employee = employee_dict[employees_months[e][-1]][e]
			print("   ", len(employees_months[e]), "\t\t", employees_months[e][-1], "\t\t", e, "\t\t", employee.supervisor)
			fired_ids += employee.user_id + "\n"
			fired_emails += employee.email + "\n"
			i += 1
			#if ("11/01/2017" in employees_months[e]):
			#	print("TTTTTTTTTTTTTTT")
	f = open("fired_ids.txt", "w")
	f.write(fired_ids)
	f.close()
	f = open("fired_emails.txt", "w")
	f.write(fired_emails)
	f.close()



csv = open("./SecurityData/employee_info.csv", "r")
data = csv.read().split("\n")[1:]

parse_data(data)

#print_employees_for_month(roots["05/01/2017"])

#find_employee("Palmer Nathaniel Church")
#find_employee("Cedric Cyrus Harrison")
#find_employee("Chaney Sean Fuentes")
find_employee("Castor Chaim Combs")
find_employee("Theodore Upton Barry")

#print("\n\n")

find_fired_employees()