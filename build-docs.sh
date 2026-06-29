#!/usr/bin/env bash
#
# build-docs.sh — ARHelloFace DocC 정적 사이트 빌드 스크립트
#
# GitHub Pages(docs/)용 정적 사이트를 한 번에 빌드합니다.
#
# 이 스크립트가 자동으로 처리하는 것:
#   1) 심볼 그래프 생성 (xcodebuild docbuild)
#   2) 공백/한글이 포함된 경로에서 docc가 튜토리얼을 누락하는 문제 우회
#      → 카탈로그를 공백 없는 임시 경로로 복사한 뒤 빌드
#   3) 정적 호스팅 변환 (--transform-for-static-hosting, base-path = ARHelloFace)
#   4) 수동 보정 재적용
#      - 루트 index.html → 튜토리얼로 리다이렉트
#      - 404.html       → 딥링크 폴백(앱 셸)
#      - .nojekyll      → GitHub Pages Jekyll 비활성화
#
# 사용법:
#   ./build-docs.sh
#
set -euo pipefail

# ── 설정 ──────────────────────────────────────────────────────────
SCHEME="ARHelloFace-Package"
BUNDLE_ID="arhelloface.ARHelloFace"
DISPLAY_NAME="ARHelloFace"
HOSTING_BASE_PATH="ARHelloFace"
TUTORIALS_PATH="tutorials/arhelloface/"   # 루트 진입 시 이동할 경로

# 스크립트 위치 = 레포 루트 (경로에 공백/한글이 있어도 안전)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CATALOG="$REPO_ROOT/Sources/ARHelloFace/ARHelloFace.docc"
DERIVED="$REPO_ROOT/DerivedData"
OUT="$REPO_ROOT/docs"

echo "▶ 레포 루트: $REPO_ROOT"

# ── 1) 심볼 그래프 생성 ───────────────────────────────────────────
echo "▶ [1/4] 심볼 그래프 빌드 (xcodebuild docbuild)…"
xcodebuild docbuild \
  -scheme "$SCHEME" \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "$DERIVED" \
  >/dev/null

SYMBOL_GRAPH="$(find "$DERIVED" -type d -name symbol-graph | head -1)"
if [[ -z "$SYMBOL_GRAPH" ]]; then
  echo "✖ 심볼 그래프를 찾을 수 없습니다." >&2
  exit 1
fi
echo "  심볼 그래프: $SYMBOL_GRAPH"

# ── 2) 공백 없는 임시 경로로 복사 후 변환 ─────────────────────────
echo "▶ [2/4] 임시 경로에서 DocC 변환…"
TMP="$(mktemp -d)"                       # macOS의 $TMPDIR은 공백이 없음
trap 'rm -rf "$TMP"' EXIT
cp -R "$CATALOG" "$TMP/ARHelloFace.docc"
cp -R "$SYMBOL_GRAPH" "$TMP/sg"

# 기대 튜토리얼 개수 = Tutorials/ 안의 .tutorial 챕터 파일 수
EXPECTED_TUTORIALS="$(find "$CATALOG/Tutorials" -maxdepth 1 -name '*.tutorial' | wc -l | tr -d ' ')"

# DocC는 간헐적으로 튜토리얼 일부를 조용히 누락한다(에러 없이). 개수를
# 검증하고 부족하면 재시도한다.
MAX_TRIES=4
BUILT=0
for try in $(seq 1 "$MAX_TRIES"); do
  rm -rf "$TMP/out"
  xcrun docc convert "$TMP/ARHelloFace.docc" \
    --fallback-display-name "$DISPLAY_NAME" \
    --fallback-bundle-identifier "$BUNDLE_ID" \
    --additional-symbol-graph-dir "$TMP/sg" \
    --emit-lmdb-index \
    --transform-for-static-hosting \
    --hosting-base-path "$HOSTING_BASE_PATH" \
    --output-path "$TMP/out"

  GOT="$(find "$TMP/out/data/tutorials" -mindepth 2 -name '*.json' 2>/dev/null | wc -l | tr -d ' ')"
  if [[ "$GOT" -ge "$EXPECTED_TUTORIALS" ]]; then
    echo "  튜토리얼 $GOT/$EXPECTED_TUTORIALS 생성 확인 (시도 $try)"
    BUILT=1
    break
  fi
  echo "  ⚠ 튜토리얼 $GOT/$EXPECTED_TUTORIALS — DocC가 일부를 누락함. 재시도($try/$MAX_TRIES)…"
done

if [[ "$BUILT" -ne 1 ]]; then
  echo "✖ $MAX_TRIES회 시도 후에도 튜토리얼이 모두 생성되지 않았습니다. docs/ 를 변경하지 않고 중단합니다." >&2
  exit 1
fi

# ── 3) docs/ 교체 ─────────────────────────────────────────────────
echo "▶ [3/4] docs/ 교체…"
rm -rf "$OUT"
cp -R "$TMP/out" "$OUT"

# ── 4) 수동 보정 재적용 ───────────────────────────────────────────
echo "▶ [4/4] 수동 보정 적용 (404 / 리다이렉트 / .nojekyll)…"
# 404.html = DocC 앱 셸(딥링크 폴백). 변환 직후의 index.html이 곧 앱 셸이다.
cp "$OUT/index.html" "$OUT/404.html"
# GitHub Pages가 _ 로 시작하는 폴더를 무시하지 않도록 Jekyll 비활성화
touch "$OUT/.nojekyll"
# 루트 index.html → 튜토리얼로 리다이렉트
cat > "$OUT/index.html" <<HTML
<!doctype html><html lang="ko"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"><link rel="icon" href="/${HOSTING_BASE_PATH}/favicon.ico"><title>${DISPLAY_NAME} 튜토리얼</title><meta http-equiv="refresh" content="0; url=/${HOSTING_BASE_PATH}/${TUTORIALS_PATH}"><script>window.location.replace("/${HOSTING_BASE_PATH}/${TUTORIALS_PATH}")</script></head><body><p>튜토리얼로 이동 중입니다… 이동되지 않으면 <a href="/${HOSTING_BASE_PATH}/${TUTORIALS_PATH}">여기를 클릭하세요</a>.</p></body></html>
HTML

echo ""
echo "✅ 완료! docs/ 가 갱신되었습니다."
echo "   로컬 미리보기 (base-path가 /${HOSTING_BASE_PATH}/ 라 심볼릭 링크로 띄웁니다):"
echo "     PREVIEW=\$(mktemp -d) && ln -s \"$OUT\" \"\$PREVIEW/${HOSTING_BASE_PATH}\" && (cd \"\$PREVIEW\" && python3 -m http.server 8000)"
echo "     → http://localhost:8000/${HOSTING_BASE_PATH}/"
