from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity, get_csrf_token, current_user
from flask_restx import Api, Resource, Namespace
import boto3
from werkzeug.datastructures import FileStorage

userapi = Namespace('users', description='Users API')

@userapi.route('/')
class Users(Resource):
    # @jwt_required
    def get(self):
        return {'message': 'Hi!. This is a GET response'}

    # @jwt_required
    def post(self):
        return {'message': 'Hi!. This is a Post response'}