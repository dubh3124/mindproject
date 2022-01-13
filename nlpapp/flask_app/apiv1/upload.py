from flask import Blueprint, jsonify, request, Response
from flask_restx import Api, Resource, Namespace
import boto3
import logging
import base64
import os

log = logging.getLogger(__name__)
devicesapi = Namespace('devices', description='Devices API')

@devicesapi.route('/')
class Devices(Resource):
    def get(self):
        bucket = os.environ["S3_UPLOAD_BUCKET"]
        client = boto3.client('s3',
                              region_name='us-east-1')
        resp = client.list_objects_v2(Bucket=bucket)

        return jsonify({"TelemetryDataDownloads": [obj["Key"] for obj in resp["Contents"]]})

@devicesapi.route('/<string:deviceid>')
class Devices(Resource):
    def get(self, deviceid):
        try:
            bucket = os.environ["S3_UPLOAD_BUCKET"]
            client = boto3.client('s3',region_name='us-east-1')
            obj = client.get_object(Bucket=bucket, Key=deviceid)
            return Response(base64.b64encode(obj['Body'].read()), mimetype="application/octet-stream")
        except Exception:
            log.exception(f"Error Getting file for Device ID - {deviceid}")

    def put(self, deviceid):
        try:
            bucket = os.environ["S3_UPLOAD_BUCKET"]
            device_file = request.files['file']

            client = boto3.client('s3',
                                  region_name='us-east-1')

            client.put_object(Body=device_file,
                              Bucket=bucket,
                              Key=deviceid)

            return {'message': f'File uploaded for Device ID - {deviceid}'}
        except Exception:
            log.exception("Oops!")
            return {'message': f"Error Uploading file for Device ID- {deviceid}"}