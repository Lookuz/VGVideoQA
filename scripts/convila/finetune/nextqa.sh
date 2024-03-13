result_dir="/home/users/nus/e0176617/SeViLA/outputs/nextqa"
exp_name='finetune'
checkpoint='checkpoints/sevila_pretrained.pth'
cfg_path='lavis/projects/convila/train/nextqa.yaml'
task='end-to-end'

# Note: No spaces or dashes to be used in the data paths, as absolute paths are computed and formatted within the LAVIS code
train_path='/scratch/users/nus/e0176617/datasets/nextqa/processed/train.json'
val_path='/scratch/users/nus/e0176617/datasets/nextqa/processed/val.json'
test_path='/scratch/users/nus/e0176617/datasets/nextqa/processed/test.json'
video_path='/scratch/users/nus/e0176617/datasets/nextqa/videos'
embeddings_path='/scratch/users/nus/e0176617/datasets/nextqa/embeddings'

batch_size=2
accum_grad_iters=2
n_frms=32

CUDA_VISIBLE_DEVICES=0 python -m torch.distributed.run --nproc_per_node=1 train.py \
    --cfg-path ${cfg_path} \
    --options run.output_dir=${result_dir}_${exp_name} \
    model.num_keyframes=4 \
    model.task=${task} \
    model.finetuned=${checkpoint} \
    datasets.nextqa.vis_processor.train.n_frms=${n_frms} \
    datasets.nextqa.vis_processor.eval.n_frms=${n_frms} \
    datasets.nextqa.build_info.annotations.train.storage=${train_path} \
    datasets.nextqa.build_info.annotations.val.storage=${val_path} \
    datasets.nextqa.build_info.annotations.test.storage=${test_path} \
    datasets.nextqa.build_info.videos.storage=${video_path} \
    datasets.nextqa.build_info.embeddings.storage=${embeddings_path} \
    run.batch_size_train=${batch_size} \
    run.batch_size_eval=${batch_size} \
    run.accum_grad_iters=${accum_grad_iters} \
    run.init_lr=3e-5 \
    run.max_epoch=1 \
    run.warmup_steps=1000 \