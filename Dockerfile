# FROM astrocrpublic.azurecr.io/runtime:3.0-5

# # Install dbt-core and adapters
# RUN pip install dbt-core dbt-snowflake dbt-databricks apache-airflow-providers-dbt-cloud

# COPY . /usr/local/airflow

# ──────────────────────────────────────────────────────────────────────────────
# 1) Base image with Airflow pre‑installed
FROM astrocrpublic.azurecr.io/runtime:3.0-5

USER root

# 2) Install system dependency: git
RUN apt-get update \
 && apt-get install -y git \
 && rm -rf /var/lib/apt/lists/*

# 3) Install dbt core + adapters + Airflow dbt provider
RUN pip install --upgrade --no-cache-dir \
    dbt-core \
    dbt-databricks \
    apache-airflow-providers-dbt-cloud

# 4) Create directories for your dbt project and profiles
RUN mkdir -p /usr/local/airflow/dbt_proj /usr/local/airflow/.dbt

# 5) Copy in your dbt project code
COPY dbt_proj/ /usr/local/airflow/dbt_proj/

# 6) Copy in your profiles.yml so dbt can authenticate
COPY .dbt/profiles.yml /usr/local/airflow/.dbt/profiles.yml

# 7) Fix ownership so the 'astro' user can write logs/target/
RUN chown -R astro:astro /usr/local/airflow/dbt_proj \
                         /usr/local/airflow/.dbt

# 8) Switch back to the non‑root astro user
USER astro



