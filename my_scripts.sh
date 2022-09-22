# downloading the models
wget https://paddleocr.bj.bcebos.com/PP-OCRv3/english/en_PP-OCRv3_det_infer.tar
wget https://paddleocr.bj.bcebos.com/dygraph_v2.0/ch/ch_ppocr_mobile_v2.0_cls_infer.tar
wget https://paddleocr.bj.bcebos.com/PP-OCRv3/english/en_PP-OCRv3_rec_infer.tar

# install paddle2onnx
pip install paddle2onnx
pip install onnxruntime

# convert models to ONNX
paddle2onnx --model_dir ./models/en_PP-OCRv3_det_infer \
--model_filename inference.pdmodel \
--params_filename inference.pdiparams \
--save_file ./models/det_onnx/model.onnx \
--opset_version 10 \
--input_shape_dict="{'x':[-1,3,-1,-1]}" \
--enable_onnx_checker True

paddle2onnx --model_dir ./models/en_PP-OCRv3_rec_infer \
--model_filename inference.pdmodel \
--params_filename inference.pdiparams \
--save_file ./models/rec_onnx/model.onnx \
--opset_version 10 \
--input_shape_dict="{'x':[-1,3,-1,-1]}" \
--enable_onnx_checker True

paddle2onnx --model_dir ./models/ch_ppocr_mobile_v2.0_cls_infer \
--model_filename inference.pdmodel \
--params_filename inference.pdiparams \
--save_file ./models/cls_onnx/model.onnx \
--opset_version 10 \
--input_shape_dict="{'x':[-1,3,-1,-1]}" \
--enable_onnx_checker True

# test example
python tools/infer/predict_system.py --use_gpu=False --use_onnx=True \
--det_model_dir=./models/det_onnx/model.onnx  \
--rec_model_dir=./models/rec_onnx/model.onnx  \
--cls_model_dir=./models/cls_onnx/model.onnx  \
--image_dir=./deploy/lite/imgs/lite_demo.png