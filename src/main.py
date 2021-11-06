from google.cloud import bigquery

client = bigquery.Client()
sql_files = ['q1.sql', 'q2.sql', 'q3.sql']


def bq_query(query_string):
    job_config = bigquery.QueryJobConfig(use_legacy_sql=False)
    query_job = client.query(query_string, job_config=job_config)
    return query_job


def execute_questions():
    for sql_file_name in sql_files:
        with open('./sql/{}'.format(sql_file_name)) as sql_file:
            query_string = sql_file.read()
            sql_file.close()
        query = bq_query(query_string)
        query.result()
        job_id = query.job_id
        total_bytes_billed = '{:,.0f}'.format(query.total_bytes_billed/float(1 << 20))+" MB"
        print('sql_file: {} with job_id: {} bill: {}'.format(sql_file_name, job_id, total_bytes_billed))


if __name__ == '__main__':
    execute_questions()