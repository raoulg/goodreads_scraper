# Use Lambda specific node image
FROM public.ecr.aws/lambda/nodejs:16

COPY index.js ${LAMBDA_TASK_ROOT}

CMD [ "index.handler" ]
