
# Math Score Prediction

## Mission and Problem Statement

This project addresses the mission of **improving academic performance prediction** by building a model that predicts students' math scores based on academic and socio-demographic attributes. The goal is to help educators identify at-risk students and allocate support early.

---

## Project Structure

```
math-score-prediction/
│
├── notebook/
│   ├── data/                               # contains dataset
│   ├── EDA STUDENT PERFORMANCE.ipynb       # Evaluate dataset entities and their relationship 
│   ├── MODEL TRAINING.ipynb                # Model training and evaluation notebook
│
├── api/
│   ├── main.py                             # FastAPI server script
│   ├── math_score_model.pkl                # Saved predition model that we will use
│
├── mathScorePrediction/                    # Flutter mobile application
|
├── requirements.txt                        # Python dependencies for deployment
```

### Video Demonstration

- **YouTube Video Link**: [https://youtu.be/tFUUrJ0zOT8](https://youtu.be/tFUUrJ0zOT8)
- Covers:
  - Mobile app prediction
  - Swagger UI testing with valid/invalid data
  - Flutter API call code
  - Notebook walkthrough
  - Model performance comparison and justification

---

## Features Covered

### Linear Regression

- Dataset: [Student Performance Dataset](https://www.kaggle.com/datasets/spscientist/students-performance-in-exams?datasetId=74977) from kaggle
- Visualizations and interpretation of categorical/numerical features
- Feature engineering: encoding,  standardizing numeric data
- Linear Regression model creation using **Scikit-learn**, optimized and visualized
- Performance comparison with **Decision Tree** and **Random Forest**
- Final model selection: **Linear Regression** (based on interpretability and reasonable performance)
- Saved model using `joblib` and exported in a pipeline
- Plotting:
  - Loss curve
  - Regression line (Actual vs Predicted)
  - Error comparison table

### FastAPI + Swagger UI

- Created a POST endpoint at `/predict` using FastAPI
- Used `pydantic` to validate input types 
- Added **CORS middleware** for cross-origin API calls
- Deployed the API to Render.com

**Live Swagger URL**: [https://math-score-prediction-jv5y.onrender.com/docs](https://math-score-prediction-jv5y.onrender.com/docs)

### Flutter Mobile App

- Developed with Flutter using Dart
- Inputs:
  - TextFields for each of the model’s input variables
    - gender
    - race_ethnicity
    - parental_level_of_education
    - lunch
    - test_preparation_course
    - reading_score
    - writing_score
- Output:
  - Displays predicted math score
  - Shows error if there is one
- Organized layout with proper alignment and spacing

---

## How to Run the Mobile App

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Emmanuel-kwizera/math-score-prediction.git
   cd math-score-prediction/mathScorePrediction
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

> Make sure your phone/emulator is running and your API endpoint is live on the internet (not localhost).

---

## API Usage Guide

### Endpoint
```http
POST /predict
```

### Request Example:
```json
{
  "gender": "female",
  "race_ethnicity": "group C",
  "parental_level_of_education": "some college",
  "lunch": "standard",
  "test_preparation_course": "completed",
  "reading_score": 90,
  "writing_score": 88
}
```

### Response Example:
```json
{
  "predicted_math_score": 77.93786547507084
}
```

