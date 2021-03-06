#!/bin/bash

#### local path
SQUAD_DIR=SQUAD
INIT_CKPT_DIR=gs://run_bert_tpu/xlnet/xlnet_cased_L-12_H-768_A-12
#### google storage path
GS_ROOT=gs://run_bert_tpu/xlnet
GS_INIT_CKPT_DIR=${GS_ROOT}/${INIT_CKPT_DIR}
GS_PROC_DATA_DIR=${GS_ROOT}/proc_data/squad
GS_MODEL_DIR=${GS_ROOT}/experiment/squad

# TPU name in google cloud

python run_squad.py \
  --use_tpu=True \
  --tpu=${TPU_NAME} \
  --num_hosts=1 \
  --num_core_per_host=8 \
  --model_config_path=${SQUAD_DIR}/xlnet_config.json \
  --spiece_model_file=${SQUAD_DIR}/spiece.model \
  --output_dir=${GS_PROC_DATA_DIR} \
  --init_checkpoint=${INIT_CKPT_DIR}/xlnet_model.ckpt \
  --model_dir=${GS_MODEL_DIR} \
  --train_file=${SQUAD_DIR}/train-v2.0.json \
  --predict_file=${SQUAD_DIR}/convHighConf-v3-wordflip-rem-num.json \
  --uncased=False \
  --max_seq_length=512 \
  --do_train=False \
  --train_batch_size=48 \
  --do_predict=True \
  --predict_batch_size=32 \
  --learning_rate=3e-5 \
  --adam_epsilon=1e-6 \
  --iterations=1000 \
  --save_steps=1000 \
  --train_steps=8000 \
  --warmup_steps=1000 \
  $@


#### local path
SQUAD_DIR=SQUAD

#### google storage path
GS_ROOT=gs://run_bert_tpu/xlnet
GS_PROC_DATA_DIR=${GS_ROOT}/proc_data/squad

python run_squad.py \
  --use_tpu=False \
  --do_prepro=True \
  --spiece_model_file=${SQUAD_DIR}/spiece.model \
  --train_file=${SQUAD_DIR}/train-v2.0.json \
  --output_dir=${GS_PROC_DATA_DIR} \
  --uncased=False \
  --max_seq_length=512 \
  $@