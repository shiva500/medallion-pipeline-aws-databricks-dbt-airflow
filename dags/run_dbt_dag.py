# dags/run_dbt_dag.py
from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="dbt_cli_job",
    default_args=default_args,
    start_date=datetime(2025, 7, 23),
    schedule="@daily",
    catchup=False,
    tags=["dbt"],
) as dag:

    dbt_env = {"DBT_PROFILES_DIR": "/usr/local/airflow/.dbt",
               "DBT_SEND_ANONYMOUS_USAGE_STATS": "false",}

    dbt_run = BashOperator(
        task_id="run_dbt_models",
        cwd="/usr/local/airflow/dbt_proj",
        bash_command="""
            set -eux
            rm -rf target
            dbt debug --profiles-dir $DBT_PROFILES_DIR
            dbt run --debug
        """,
        env=dbt_env,
    )

    dbt_test = BashOperator(
        task_id="test_dbt_models",
        cwd="/usr/local/airflow/dbt_proj",
        bash_command="""
            set -eux
            dbt test --debug
        """,
        env=dbt_env,
    )

    dbt_run >> dbt_test
