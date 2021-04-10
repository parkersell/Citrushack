import text2emotion as te
import pandas as pd
from textblob import TextBlob
from textblob.sentiments import NaiveBayesAnalyzer

def empathy(prompt, response):
    #print(te.get_emotion(prompt))
    #print(te.get_emotion(response))

    #print(TextBlob(prompt, analyzer=NaiveBayesAnalyzer()).sentiment)
    #print(TextBlob(response, analyzer=NaiveBayesAnalyzer()).sentiment)

    # Gets just the emotion values for each statement.
    promptEmotions = te.get_emotion(prompt).values()
    responseEmotions = te.get_emotion(response).values()

    # Calculates the distance between the emotion vectors.
    return 5 - ((sum(pow(float(a)-float(b),2) for a, b in zip(promptEmotions, responseEmotions)) * 8) ** (1/2))

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
        s1words = [s.replace("_comma_", ",") for s in s1["utterance"].values.tolist()]
        s2words = [s.replace("_comma_", ",") for s in s2["utterance"].values.tolist()]
        context = convo["context"].str.extract('(\w+)').values[0].item()
        escore = int(convo["empathy"].values[0])
        prompt = [convo["prompt"].unique()[0]]
        lsconv.append([context, prompt + s1words, s2words, escore])
    return lsconv

def testing(n):
    conversations = getConversations(n)
    error = 0
    for conversation in conversations:
        person1 = " ".join(conversation[1])
        person2 = " ".join(conversation[2])
        #print(person2)
        #print("Prompt Length: " + str(len(person1)))
        #print("Response Length: " + str(len(person2)))
        temp = conversation[3] - empathy(person1, person2)
        error += abs(temp)
    print(error / n)