from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime
from src.data.load import load_data
from src.data.preprocess import preprocess_data
from src.features.build_features import build_features
from src.models.train import train_model
from src.mlflow.tracking import log_experiment

default_args = {
    'owner': 'mlops_team',
    'depends_on_past': False,
    'start_date': datetime(2023, 10, 1),
    'retries': 1,
}

dag = DAG(
    'product_classification_dag',
    default_args=default_args,
    description='A DAG for the product classification MLOps pipeline',
    schedule_interval='@daily',
)

load_task = PythonOperator(
    task_id='load_data',
    python_callable=load_data,
    dag=dag,
)

preprocess_task = PythonOperator(
    task_id='preprocess_data',
    python_callable=preprocess_data,
    dag=dag,
)

feature_engineering_task = PythonOperator(
    task_id='build_features',
    python_callable=build_features,
    dag=dag,
)

train_task = PythonOperator(
    task_id='train_model',
    python_callable=train_model,
    dag=dag,
)

log_experiment_task = PythonOperator(
    task_id='log_experiment',
    python_callable=log_experiment,
    dag=dag,
)

load_task >> preprocess_task >> feature_engineering_task >> train_task >> log_experiment_task