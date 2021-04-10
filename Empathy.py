import text2emotion as te

def empathy(prompt, response):
    print(te.get_emotion(prompt))
    print(te.get_emotion(response))

    # Gets just the emotion values for each statement.
    promptEmotions = te.get_emotion(prompt).values()
    responseEmotions = te.get_emotion(response).values()

    # Calculates the distance between the emotion vectors.
    return (sum(pow(float(a)-float(b),2) for a, b in zip(promptEmotions, responseEmotions))) ** (1/2)
