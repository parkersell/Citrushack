import text2emotion as te
import pandas as pd
from textblob import TextBlob
from textblob.sentiments import NaiveBayesAnalyzer

def minus(score, x):
    if score >= 1 + x:
        score -= x
    elif score < x:
        score = 1
    return score

def add(score, x):
    if score + x <= 5:
        score += x
    else:
        score = 5
    return score

def empathy(prompt, response):
    # print(te.get_emotion(prompt))
    # print(te.get_emotion(response))

    #print(TextBlob(prompt, analyzer=NaiveBayesAnalyzer()).sentiment)
    #print(TextBlob(response, analyzer=NaiveBayesAnalyzer()).sentiment)

    # Gets just the emotion values for each statement.
    promptEmotions = list(te.get_emotion(prompt).values())
    print(prompt)
    responseEmotions = list(te.get_emotion(response).values())

    # Calculates the distance between the emotion vectors.
    score = 5 - ((sum(pow(float(a)-float(b), 2)
                 for a, b in zip(promptEmotions, responseEmotions)) * 8) ** (1/2))

    # subtracts one from score if word length is less than 10.
    print(len(response.split(" ")))
    if len(response.split(" ")) < 6:
        score = minus(score, 3)
    elif len(response.split(" ")) < 8:
        score = minus(score, 2)
    elif len(response.split(" ")) < 10:
        score = minus(score, 1)

    if len(response.split(" ")) > 15:
        score = add(score, 1)

    if promptEmotions[1] > .5:
        if responseEmotions[1] > .5:
            print("Your response is too angry")
            score = minus(score, 1)

    if "but" in response:
        print("Wouldn't recommend using the word but, since it sounds like you aren't listening.")
        score = minus(score, .5)

    return round(score)

def getConversations(n):
    train = pd.read_csv("train.csv")
    train = train.iloc[:, :7].dropna()
    selfeval = train['selfeval']
    train["empathy"] = selfeval.str.extract('\d\|\d\|\d_(\d)\|\d\|\d')
    train = train.dropna()
    conversations = train["conv_id"].value_counts()
    conversations = conversations.iloc[:n]
    lsconv = []
    for ids in conversations.index:
        convo = train.loc[train["conv_id"] == ids]
        convo = convo.drop(columns=["utterance_idx", "selfeval", "conv_id"])
        s1id = convo["speaker_idx"].unique()[0]
        s2id = convo["speaker_idx"].unique()[1]
        s1 = convo.loc[convo["speaker_idx"] == s1id]
        s2 = convo.loc[convo["speaker_idx"] == s2id]
        s1words = [s.replace("_comma_", ",")
                   for s in s1["utterance"].values.tolist()]
        s2words = [s.replace("_comma_", ",")
                   for s in s2["utterance"].values.tolist()]
        context = convo["context"].str.extract('(\w+)').values[0].item()
        escore = int(convo["empathy"].values[0])
        prompt = [convo["prompt"].unique()[0]]
        lsconv.append([context, prompt + s1words, s2words, escore])
    return lsconv


def readTest(csv):
    train = pd.read_csv(csv)
    trainlist = train.values.tolist()
    return trainlist


def testing(csv):
    conversations = readTest(csv)
    error = 0
    count = 1
    for conversation in conversations:
        seedEmotions = list(map(float, conversation[0:5]))
        total = sum(seedEmotions)
        for i in range(0, len(seedEmotions)):
            seedEmotions[i] = seedEmotions[i] / total
        person1 = "".join(conversation[5])
        person2 = "".join(conversation[6])
        # print(person2)
        escore = empathy(person1, person2)

        temp = conversation[7] - escore
        print(count, escore, conversation[7])
        count += 1
        error += abs(temp)
    print(error / len(conversations))
