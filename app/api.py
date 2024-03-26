from flask import Flask, jsonify, request
import time
import logging

app_name = 'comentarios'
app = Flask(app_name)
app.debug = True

comments = {}

# Configuração para coleta de métricas #
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.before_request
def before_request():
    request.start_time = time.time()

@app.after_request
def after_request(response):
    if hasattr(request, 'start_time'):
        runtime = time.time() - request.start_time
        status_code = response.status_code
        method = request.method
        path = request.path
        remote_addr = request.remote_addr
        content_length = response.calculate_content_length()
        logger.info("%s %s %s %s %s %s", method, path, status_code, runtime, remote_addr, content_length)
    return response
######################################

@app.route('/api/comment/new', methods=['POST'])
def api_comment_new():
    request_data = request.get_json()

    email = request_data['email']
    comment = request_data['comment']
    content_id = '{}'.format(request_data['content_id'])

    new_comment = {
        'email': email,
        'comment': comment,
    }

    if content_id in comments:
        comments[content_id].append(new_comment)
    else:
        comments[content_id] = [new_comment]

    message = 'comment created and associated with content_id {}'.format(content_id)
    response = {
        'status': 'SUCCESS',
        'message': message,
    }
    return jsonify(response)

@app.route('/api/comment/list/<content_id>')
def api_comment_list(content_id):
    content_id = '{}'.format(content_id)

    if content_id in comments:
        return jsonify(comments[content_id])
    else:
        message = 'content_id {} not found'.format(content_id)
        response = {
            'status': 'NOT-FOUND',
            'message': message,
        }
        return jsonify(response), 404

# Rota para health check do Target Group #

@app.route('/')
def index():
    return 'Application running', 200

if __name__ == "__main__":
    app.run()

##########################################