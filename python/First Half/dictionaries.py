#just some example code for dictionary stuff as reference

#curly braces
abbreviations = {'lol': 'laugh out loud', 'omw': 'on my way',
'prndl': 'park reverse neutral drive level'}

#can access same as lists
print(abbreviations['lol'])

#better to use .get in the event key is not found
#print(abbreviations['wtf'])
print(abbreviations.get('wtf', 'thats a no no word'))

print(abbreviations.keys())
print(abbreviations.values())

#reassignment
abbreviations['tgif'] = 'thank god its friday'
