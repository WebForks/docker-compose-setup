# docker-compose-setup

To run the script, follow these steps:

    Open a terminal window in Ubuntu.
    Create a new file with the script content using any text editor. For example, you can use the nano text editor by running sudo nano script.sh.
    Copy and paste the script content into the file.
    Save the file and close the text editor.
    Make the script executable by running sudo chmod +x script.sh.
    Finally, run the script by typing ./script.sh in the terminal window.

The script will then automatically install Docker and Docker Compose, create a docker-compose directory in the user's home directory, and create a Docker Compose file for the specified services. It will also run docker-compose up -d to start the containers.