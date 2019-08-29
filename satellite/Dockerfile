# storjlabs/kub/setup must already built
FROM scratch AS deploy
# Copy user and group info from the build box
COPY --from=storjlabs/kub/setup:latest  /etc/passwd /etc/passwd
COPY --from=storjlabs/kub/setup:latest  /etc/group /etc/group
COPY --chown=storj:storj --from=storjlabs/kub/setup:latest /home/storj /home/storj
COPY --chown=storj:storj --from=storjlabs/kub/setup:latest /satellite /satellite
# Allow only 'satellite' to be run and default to user 'storj'
USER storj:storj
#ENTRYPOINT [ "/satellite" ]
#CMD [ "run"]