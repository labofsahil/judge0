wrk.method = "POST"
wrk.headers["Content-Type"] = "application/json"
wrk.headers["X-Authz-Token"] = "bench-token"
wrk.body = '{"source_code":"cHV0cyAx","language_id":46,"stdin":"","expected_output":"MQ==","base64_encoded":true}'
