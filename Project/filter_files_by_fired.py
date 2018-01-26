fired_ids = open("fired_ids.txt", "r").read().strip().split("\n")
print(len(fired_ids))
fired_emails = open("fired_emails.txt", "r").read().strip().split("\n")
print(len(fired_emails))

id_files = ["device_info.csv", "logon_info.csv", "http_info.csv", "employee_info.csv"]
email_files = ["email_info.csv"]

def has_id(line, fired_identifiers):
	fired = False
	for id in fired_identifiers:
		if id in line:
			fired = True
			break
	return fired


for file in id_files:
	open("./SecurityData/new_" + file, "w").writelines(line for line in open("./SecurityData/" + file) if has_id(line, fired_ids))
for file in email_files:
	open("./SecurityData/new_" + file, "w").writelines(line for line in open("./SecurityData/" + file) if has_id(line, fired_emails))