import datetime

from airflow import models
from airflow.operators import bash_operator

default_dag_args = {
  'start_date': datetime.datetime(2022, 7, 19, 16, 50),
  'retries': 1,
  'retry_delay': datetime.timedelta(minutes=2),
  # 'project_id': models.Variable.get('gcp_project') # valkoiset
  'project_id': 'valkoiset'
}

# source_bucket = models.Variable.get('gcs_source_bucket') # gs://spikey_catalog_image_bucket_mine
# dest_bucket = models.Variable.get('gcs_dest_bucket') # gs://spikey_catalog_image_bucket_backup_mine
source_bucket = 'gs://spikey_catalog_image_bucket_mine'
dest_bucket = 'gs://spikey_catalog_image_bucket_backup_mine'

with models.DAG(
  'transferring_data_from_gcs_to_gcs',
  schedule_interval=None,
  default_args=default_dag_args) as dag:

  transfer_data_gcs_to_gcs = bash_operator.BashOperator(
    task_id='data_transfer_gcs_to_gcs',
    bash_command=f'gsutil cp -r {source_bucket} {dest_bucket}'
  )

  transfer_data_gcs_to_gcs

# gcloud composer environments run spikey-test-environment \
#   --location europe-west1 variables -- \
#   --set gcp_project valkoiset

# the same as in video found in documentation
# gcloud composer environments run spikey-test-environment \
#     --location europe-west1 variables -- --set gcp_project valkoiset

# gcloud composer environments run spikey-test-environment \
#   --location europe-west1 variables -- \
#   --set gcs_source_bucket gs://spikey_catalog_image_bucket_mine

# gcloud composer environments run spikey-test-environment \
#   --location europe-west1 variables -- \
#   --set gcs_source_bucket gs://spikey_catalog_image_bucket_backup_mine
# -----------------------------------------------------------------------------

# https://cloud.google.com/composer/docs/how-to/managing/environment-variables#gcloud
# gcloud composer environments update \
#   spikey-test-environment \
#   --location europe-west1 \
#   --update-env-variables=gcs_dest_bucket=gs://spikey_catalog_image_bucket_backup_mine
  # --update-env-variables=gcs_source_bucket=gs://spikey_catalog_image_bucket_mine
  # --update-env-variables=gcp_project=valkoiset

# --update-env-variables=gcp_project=valkoiset, gcs_source_bucket=gs://spikey_catalog_image_bucket_mine, gcs_dest_bucket=gs://spikey_catalog_image_bucket_backup_mine

# gcloud composer environments update spikey-test-environment --location europe-west1 --clear-env-variables
