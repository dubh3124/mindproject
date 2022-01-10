from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity, get_csrf_token, current_user
from flask_restx import Api, Resource, Namespace
import boto3
import logging
from werkzeug.datastructures import FileStorage

log = logging.getLogger(__name__)
uploadapi = Namespace('upload', description='Upload API')

@uploadapi.route('/')
class Upload(Resource):
    # @jwt_required
    def get(self):
        bucket = 'nlpupload-nlpappp-dev'
        client = boto3.client('s3',
                              region_name='us-east-1')
                              # aws_access_key_id="AKIASNRQQR6EV2ITNGN4",  # os.environ['ACCESS_KEY'],
                              # aws_secret_access_key="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")  # os.environ['SECRET_KEY'])
        return jsonify(client.list_objects_v2(
            Bucket=bucket
        ))

    # @jwt_required
    def post(self):
        try:
            bucket = 'nlpupload-nlpappp-dev'
            content_type = request.mimetype
            image_file = request.files['file']

            client = boto3.client('s3',
                                  region_name='us-east-1')
                                  # aws_access_key_id="AKIASNRQQR6EV2ITNGN4",  # os.environ['ACCESS_KEY'],
                                  # aws_secret_access_key="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")  # os.environ['SECRET_KEY'])

            # filename = secure_filename(
            #     image_file.filename)  # This is convenient to validate your filename, otherwise just use file.filename

            client.put_object(Body=image_file,
                              Bucket=bucket,
                              Key=image_file.filename,
                              ContentType=content_type)

            return {'message': 'File Uploaded'}
        except Exception:
            log.exception("Oops!")
            return {'message': "Oops!"}