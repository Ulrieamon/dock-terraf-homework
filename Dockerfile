FROM python:3.13.11-slim

RUN pip install pandas pyarrow jupyter 

WORKDIR /dataview

#run jupyter of container
EXPOSE 8888

#run Jupyter

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
