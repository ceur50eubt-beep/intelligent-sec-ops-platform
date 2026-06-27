package main

# デフォルトは拒否（違反があればallowがfalseになる）
deny[msg] {
    # 対象がPodのリソースである場合
    input.kind == "Pod"
    image := input.spec.containers[_].image
    
    # イメージ名が "internal-registry.io/" で始まっていない場合
    not startswith(image, "internal-registry.io/")
    
    # 違反時のエラーメッセージを定義
    msg := sprintf("⚠️ セキュリティ違反: イメージ '%v' は社内公認レジストリ (internal-registry.io/) からのものではありません！", [image])
}
