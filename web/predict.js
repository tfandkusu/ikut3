// 分類モデル
var iKutModel = null;
// モデル読込済みフラグ
var iKutLoaded = false;

/// モデルを読み込む
async function loadImageClassification() {
    if (!iKutLoaded) {
        // 試合の開始モデル読込
        iKutModel = await tf.automl.loadImageClassification('model/model.json');
        // 読込完了フラグ
        iKutLoaded = true;
    }
    return 0;
}


// 分類する
async function classify(image) {
    const result = await iKutModel.classify(image);
    return JSON.stringify(result, null, 2);
}
