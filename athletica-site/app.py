from flask import Flask, request, jsonify, send_file, render_template_string
import json
import os
import datetime

app = Flask(__name__, static_folder='.', static_url_path='')

# Ensure data directory exists
DATA_DIR = 'data'
if not os.path.exists(DATA_DIR):
    os.makedirs(DATA_DIR)

DATA_FILE = os.path.join(DATA_DIR, 'submissions.json')

# Admin password (simple protection)
ADMIN_PASSWORD = "athletica-secret"

@app.route('/')
def index():
    return send_file('index.html')

@app.route('/submit', methods=['POST'])
def submit():
    try:
        data = request.json
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        # Add timestamp
        data['timestamp'] = datetime.datetime.now().isoformat()
        
        # Read existing data
        submissions = []
        if os.path.exists(DATA_FILE):
            with open(DATA_FILE, 'r', encoding='utf-8') as f:
                try:
                    submissions = json.load(f)
                except json.JSONDecodeError:
                    pass
        
        # Append new submission
        submissions.append(data)
        
        # Save back to file
        with open(DATA_FILE, 'w', encoding='utf-8') as f:
            json.dump(submissions, f, indent=4, ensure_ascii=False)
            
        return jsonify({'success': True, 'message': 'Message received'})
    except Exception as e:
        print(f"Error saving submission: {e}")
        return jsonify({'error': 'Internal server error'}), 500

@app.route('/admin')
def admin():
    # Simple password check via query param ?auth=password
    auth = request.args.get('auth')
    if auth != ADMIN_PASSWORD:
        return "<h1>Access Denied</h1><p>Please provide the correct password in the URL: /admin?auth=PASSWORD</p>", 403
    
    submissions = []
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r', encoding='utf-8') as f:
            try:
                submissions = json.load(f)
            except json.JSONDecodeError:
                pass
    
    # Sort by newest first
    submissions.reverse()
    
    html = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Athletica Admin</title>
        <style>
            body { font-family: sans-serif; padding: 20px; background: #f4f4f4; }
            table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
            th, td { padding: 12px; border-bottom: 1px solid #ddd; text-align: left; }
            th { background: #333; color: white; }
            tr:hover { background: #f5f5f5; }
            .time { color: #666; font-size: 0.9em; }
        </style>
    </head>
    <body>
        <h1>Admin Dashboard</h1>
        <p>Total Submissions: {{ count }}</p>
        <table>
            <thead>
                <tr>
                    <th>Time</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Subject</th>
                    <th>Message</th>
                </tr>
            </thead>
            <tbody>
                {% for sub in submissions %}
                <tr>
                    <td class="time">{{ sub.timestamp }}</td>
                    <td>{{ sub.name }}</td>
                    <td><a href="mailto:{{ sub.email }}">{{ sub.email }}</a></td>
                    <td>{{ sub.subject }}</td>
                    <td>{{ sub.message }}</td>
                </tr>
                {% endfor %}
            </tbody>
        </table>
    </body>
    </html>
    """
    return render_template_string(html, submissions=submissions, count=len(submissions))

if __name__ == '__main__':
    # Bind to 0.0.0.0 to be accessible externally
    app.run(host='0.0.0.0', port=8080)
