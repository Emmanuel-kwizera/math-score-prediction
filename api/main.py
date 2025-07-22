from pydantic import BaseModel
from fastapi import FastAPI
import joblib
import numpy as np
import pandas as pd
import os
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
modelPath = os.path.join(os.path.dirname(__file__), 'math_score_model.pkl')

class StudentData(BaseModel):
    gender: str
    race_ethnicity: str
    parental_level_of_education: str
    lunch: str
    test_preparation_course: str
    reading_score: float
    writing_score: float

def predict_math_score(data: StudentData):
    # Load the model
    model = joblib.load(modelPath)
    
    # Prepare the input data
    input_data = pd.DataFrame([{
        'gender': data.gender,
        'race_ethnicity': data.race_ethnicity,
        'parental_level_of_education': data.parental_level_of_education,
        'lunch': data.lunch,
        'test_preparation_course': data.test_preparation_course,
        'reading_score': data.reading_score,
        'writing_score': data.writing_score
    }])

    # Make predictions
    predictions = model.predict(input_data)
    return predictions[0]

# CORS middleware to allow requests from any origin
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/predict")
def predict(data: StudentData):
    return {"predicted_math_score": predict_math_score(data)}
