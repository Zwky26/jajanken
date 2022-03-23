# main goals for this program: needs to prompt input for bill
# then prints out various common tip amounts, like 10, 15, 20% tip

bill = input("Enter bill amount: $")
#alternatively here can do .strip('$') if $ was not coded in

def percent_calc(rate) : return rate * float(bill)

print(f"""10% tip rate: ${percent_calc(.1):.2f}
15% tip rate: ${percent_calc(.15):.2f}
20% tip rate: ${percent_calc(.2):.2f} """)
