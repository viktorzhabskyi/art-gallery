# Project Concept

This project focuses on developing a scalable online platform for virtual art galleries. The application integrates a reliable backend and a dynamic frontend. The backend manages user authentication, gallery curation, and artwork transactions, while the frontend provides a seamless and immersive user experience for exploring art collections. Additionally, caching mechanisms are employed to enhance performance, ensuring a robust and efficient user experience.


# Project Overview

This project is structured into three primary components: backend services (RDS and Redis), and the frontend. Each component plays a critical role in delivering a comprehensive solution. Below is a summary of the key elements:

- **Backend (RDS)**: Built with a focus on scalability and reliability, managing relational database operations.
- **Backend (Redis)**: Optimized for session caching and quick access to frequently used data.
- **Frontend**: Designed to provide a dynamic and interactive user interface.

The platform utilizes PostgreSQL for database management and Redis for caching, ensuring optimal performance.

### Diagram
![Architecture Diagram](diagram.png)

## File Structure

### 1. **Backend (RDS)**
- **Purpose**: Manages application logic and integrates with a relational database service.
- **Files**:
  - `manage.py`: Entry point for the backend application.
  - `requirements.txt`: Lists dependencies for the project.
  - `backend_rds/`: Contains the core backend logic, configuration files, and routes for the application.

### 2. **Backend (Redis)**
- **Purpose**: Handles backend logic with Redis for caching.
- **Files**:
  - `manage.py`: Entry point for the backend application.
  - `requirements.txt`: Lists dependencies for the project.
  - `backend_redis/`: Contains the core backend logic, configuration files, and routes for the application.

### 3. **Frontend**
- **Purpose**: Provides the user interface.
- **Files**:
  - `manage.py`: Entry point for the frontend application.
  - `requirements.txt`: Lists frontend dependencies.
  - `frontend/`: Contains configuration files, routing, views, and templates for the frontend interface.


## Lifehacks

**Use ChatGPT everywhere**

**But don't ask it to write the code or solutions for you.**

Initially, use it to understand the diagram, all the interconnections on it, and why everything is arranged this way.

Next, use it when taking courses to find the information you need for the project's implementation. Use it here to deepen your understanding, create more examples and analogies. Break concepts into the simplest levels of abstraction and show maximum creativity when working with it.

Refer back to the course we took initially (about ChatGPT), recall the methods and strategies of prompts, and use them.
Your main task is not just to implement the project but to learn how to break down new information into the simplest pieces with ChatGPT and build understanding as quickly as possible.



## Installation

1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd project
   ```

2. Navigate to each directory and install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Set up environment variables for database and application configuration. You can look up these variables in `settings.py`.

4. Start the server:
   ```bash
   python ./manage.py runserver 0.0.0.0:8000
   ```


## Deployment

### Backend Services
- Deploy the backend (backend_rds, backend_redis) services using ECS as specified in the architecture diagram.

### Frontend
- Deploy the frontend service using ECS as specified in the architecture diagram.

### Dockerization

- All services should be containerized using Docker to ensure ease of scaling and deployment.

### CI/CD Process

- Implement separate CI/CD pipelines for backend and frontend deployment to automate the process effectively.




