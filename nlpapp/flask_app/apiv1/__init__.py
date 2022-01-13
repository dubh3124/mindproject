from flask import Blueprint
from flask_restx import Api
from flask_app.apiv1.upload import devicesapi
import os


api1 = Blueprint('api1', __name__, url_prefix='/api')
api = Api(api1,
          title='NLP Device Telemetry Data',
          version='1.0',
          description= f"""
          ECS Metadata:
          {os.getenv("ECS_CONTAINER_METADATA_URI_V4", None)}
          """
          )

api.add_namespace(devicesapi)