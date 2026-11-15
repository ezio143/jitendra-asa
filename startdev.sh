#!/usr/bin/env bash
set -e

cd app
exec uvicorn main:app --reload