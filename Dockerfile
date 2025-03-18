# Ultroid - UserBot
# Copyright (C) 2021-2025 TeamUltroid
# This file is a part of < https://github.com/TeamUltroid/Ultroid/ >
# Please read the GNU Affero General Public License in <https://www.github.com/TeamUltroid/Ultroid/blob/main/LICENSE/>.

FROM theteamultroid/ultroid:main

# Set timezone
ENV TZ=Asia/Karachi
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Run as root first
COPY installer.sh .
RUN bash installer.sh

# Add cache-busting step
ARG CACHEBUST=1

# Install dependencies before switching to user
COPY ./requirements.txt requirements.txt
COPY ./resources/startup/optional-requirements.txt optional-requirements.txt
RUN pip install --no-cache-dir --upgrade --no-cache -r requirements.txt -r optional-requirements.txt

# Add new user and switch to it
RUN useradd -m -u 1000 user
USER user
ENV PATH="/home/user/.local/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy the project files
COPY --chown=user . /app

# Expose port 7860
EXPOSE 7860

# Start the bot
CMD ["bash", "-c", "python3 -m pyUltroid & python3 app.py & wait"]
