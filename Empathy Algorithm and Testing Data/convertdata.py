import text2emotion as te
import pandas as pd
import numpy as np


def getConversations(s, e):
    train = pd.read_csv("train.csv")
    train = train.iloc[:, :7].dropna()
    selfeval = train['selfeval']
    train["empathy"] = selfeval.str.extract('\d\|\d\|\d_(\d)\|\d\|\d')
    train = train.dropna()
    conversations = train["conv_id"].value_counts()
    conversations = conversations[s:e]
    lsconv = []
    for ids in conversations.index:
        convo = train.loc[train["conv_id"] == ids]
        convo = convo.drop(columns=["utterance_idx", "selfeval", "conv_id"])
        if len(convo["speaker_idx"].unique()) != 2:
            continue
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


def empathy(prompt, response):
    # Gets just the emotion values for each statement.
    promptEmotions = list(te.get_emotion(prompt).values())
    responseEmotions = list(te.get_emotion(response).values())
    # Calculates the distance between the emotion vectors.
    return promptEmotions + responseEmotions


def testing(s, e):
    conversations = getConversations(s, e)
    person1 = " ".join(conversations[0][1])
    person2 = " ".join(conversations[0][2])
    values = np.array(empathy(person1, person2))
    values = np.reshape(values, (1, 10))
    for i in range(1, len(conversations)):
        person1 = " ".join(conversations[i][1])
        person2 = " ".join(conversations[i][2])
        temp = np.array(empathy(person1, person2))
        temp = np.reshape(temp, (1, 10))
        values = np.append(values, temp, axis=0)
        if i % 100 == 0:
            print(i)
    return values


v = testing(3001, 4000)

np.save("3000s.npy", v)
