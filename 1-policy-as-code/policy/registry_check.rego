package main

# 違反があればdenyリストにメッセージが追加される（Conftest標準仕様）
deny[msg] {
    # 1. 単体Podリソースのイメージチェック
    input.kind == "Pod"
    image := input.spec.containers[_].image
    not startswith(image, "internal-registry.io/")
    msg := sprintf("⚠️ セキュリティ違反: イメージ '%v' は社内公認レジストリ (internal-registry.io/) からのものではありません！", [image])
}

deny[msg] {
    # 2. Deployment / StatefulSet / Job 等のポッドテンプレート内イメージチェック（実運用考慮）
    valid_kinds := ["Deployment", "StatefulSet", "Job", "DaemonSet"]
    input.kind == valid_kinds[_]
    image := input.spec.template.spec.containers[_].image
    not startswith(image, "internal-registry.io/")
    msg := sprintf("⚠️ セキュリティ違反 (%v): テンプレート内のイメージ '%v' は社内公認レジストリからのものではありません！", [input.kind, image])
}
