FFROM openjdk:11-jre

# Copy the font to the appropriate location.
# The font is in a ttf in the same directory as the Dockerfile.

RUN mkdir -p /usr/share/fonts/truetype
COPY arial.ttf /usr/share/fonts/truetype
COPY arialbd.ttf /usr/share/fonts/truetype
COPY arialbi.ttf /usr/share/fonts/truetype
COPY ariali.ttf /usr/share/fonts/truetype

# Rebuild the font cache.
RUN fc-cache -fv

RUN mkdir -p /app
WORKDIR /app

COPY BirtScheduler.jar /app

CMD ["java", "-jar", "/app/BirtScheduler.jar"]

EXPOSE 8085
