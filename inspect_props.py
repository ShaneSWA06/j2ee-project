
with open('src/main/resources/stripe.properties', 'rb') as f:
    content = f.read()
    print(f"Total bytes: {len(content)}")
    print(f"Content repr: {repr(content)}")
