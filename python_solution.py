PYTHON PROFICIENCY


Q1.Number of minutes,convert it into human readable form
    ex:
    130 beacomes "2hrs 10 minutes"


  minutes = int(input())
  hours = minutes // 60
  remaining_minutes = minutes % 60
  print(hours, "hrs", remaining_minutes, "minutes")


Q2.You are given a string,remove all the duplicates and print the unique string.Use loop in the python

    string = input()
    result = ""
    for char in string:
    if char not in result:
    result += char
      print(result)
