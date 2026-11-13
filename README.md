# K5-L3B-Day05-T1-ViSucKhoe

Bài LAB5 · Track T1 Y tế: AI trong kênh chat **Hỏi dược sĩ** quyết định khi nào tự gợi ý sản phẩm, khi nào hỏi lại, chuyển dược sĩ hoặc khuyên đi khám ngay. Bài làm đầy đủ ở [`spec.md`](spec.md).

## Cấu trúc

| File | Nội dung |
|---|---|
| [`spec.md`](spec.md) | Bài nộp: phạm vi, kịch bản rủi ro, mức tự chủ, prototype, tiêu chí, demo |
| [`prototype/index.html`](prototype/index.html) | Prototype một file (chat khách · màn dược sĩ · cột thiết kế) |
| [`prototype/server.mjs`](prototype/server.mjs) | Server nội bộ, gọi CKey API để phân loại tin nhắn |
| [`prototype/start-live.ps1`](prototype/start-live.ps1) | Script khởi động server |
| `prototype/0*.png` | Ảnh minh chứng S4, S8 và lời gọi AI thật |

## Cách chạy

**Bản mô phỏng (không cần key):** mở `prototype/index.html` trực tiếp bằng trình duyệt.

**Bản gọi AI thật (CKey)** — cần Node.js 20+ và PowerShell:

1. Sao chép `prototype/.env.example` thành `prototype/.env`, điền `CKEY_API_KEY=...`.
2. Tại thư mục gốc repo, chạy `./prototype/start-live.ps1`.
3. Mở `http://127.0.0.1:8787`, chọn một ca (S4, S8…) hoặc tự nhập ca dựng, rồi bấm **Gửi**.
4. Nhấn `Ctrl+C` để dừng server.

Mở `http://127.0.0.1:8787/#ai-live-test` để tự gửi ca thử “Họng mình đau rát 2 ngày nay, có thuốc gì không?”. Mỗi lần tải lại trang là một lần gọi API.

Model mặc định `deepseek-v4.1-flash` (đổi bằng `CKEY_MODEL` trong `.env`). Server chỉ nghe `127.0.0.1` và gọi [CKey `chat/completions`](https://ckey.vn/llm-api/setup).

## Lưu ý

- **Key:** chỉ để trong `prototype/.env` (đã `.gitignore`). Không đặt key trong HTML, `spec.md` hay file được commit.
- **Dữ liệu:** chỉ nhập ca dựng. Sản phẩm, hàng chờ, dược sĩ, nút Gọi 115 đều là mô phỏng.
- **Quyền của AI:** AI thật chỉ phân loại tin nhắn thành `emergency` / `transfer` / `standard`, kèm căn cứ trích nguyên văn. AI chỉ được **nâng** mức cảnh báo, không được hạ mức mà bộ luật đã đặt; không gợi ý thuốc, không kê đơn, không nói liều, không lưu hồ sơ. Nếu API lỗi, giao diện báo lỗi và dùng bộ luật mô phỏng.
