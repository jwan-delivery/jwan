


/*
 * AI JWAN — رابط صديق للمستخدم:
 * اطلب من النموذج استخدام روابط مفيدة عندما تكون ذات صلة.
 * لا تعرض URL خام للمستخدم.
 */
const JWAN_LINK_INSTRUCTIONS = `
أنت AI JWAN داخل منصة جوان للتوصيل.
عند الإجابة:
1. اجعل الإجابة واضحة ومختصرة ومفيدة.
2. استخدم الروابط المفيدة كلما كانت مرتبطة بالسؤال.
3. لا تعرض أي رابط بصيغته الخام مثل https://example.com.
4. بدلاً من ذلك استخدم Markdown:
   [اضغط هنا](URL)
   [ابدأ الآن](URL)
   [تسجيل الدخول](URL)
   [إنشاء حساب](URL)
   [فتح صفحة الطلب](URL)
   [تواصل معنا](URL)
5. إذا كانت هناك عدة صفحات مفيدة، قدّم الروابط المناسبة داخل الرد.
6. لا تخترع روابط.
7. فضّل روابط صفحات جوان المعروفة والروابط الرسمية الموثوقة.
8. إذا كان المستخدم يسأل عن إجراء يمكن تنفيذه داخل التطبيق، وجّه المستخدم مباشرة إلى الصفحة المناسبة برابط قابل للضغط.
`;

function renderJwanAIAnswer(text) {
  const value = String(text ?? "");

  const escapeHtml = (v) => v
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");

  let html = escapeHtml(value);

  // [النص](https://...)
  html = html.replace(
    /\[([^\]]{1,120})\]\((https?:\/\/[^\s)]+)\)/gi,
    (_, label, url) =>
      `<a class="jwan-ai-link" href="${url}" target="_blank" rel="noopener noreferrer">${label}</a>`
  );

  // URL خام => إخفاؤه خلف "اضغط هنا"
  html = html.replace(
    /(?<!["'=])(https?:\/\/[^\s<>"')]+)/gi,
    (url) =>
      `<a class="jwan-ai-link" href="${url}" target="_blank" rel="noopener noreferrer">اضغط هنا</a>`
  );

  // **نص**
  html = html.replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>");

  // أسطر جديدة
  html = html.replace(/\n/g, "<br>");

  return html;
}

/*


// Jwan AI — render useful links inside answers safely.
function jwanRenderAIText(text) {
  const escapeHtml = (value) => String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");

  let html = escapeHtml(text);

  html = html.replace(
    /(https?:\/\/[^\s<]+)/g,
    (url) => {
      const clean = url.replace(/[),.;!?؟]+$/g, "");
      return `<a href="${clean}" target="_blank" rel="noopener noreferrer">${clean}</a>`;
    }
  );

  html = html.replace(/\n/g, "<br>");
  return html;
}

 * JWAN AI
 * Firebase AI Logic + Gemini Developer API
 */

import {
  app,
  appCheck
} from "./firebase-config.js";

import {
  getToken
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-app-check.js";

import {
  getAI,
  getGenerativeModel,
  GoogleAIBackend
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-ai.js";

let model = null;
let geminiReady = false;

function addMessage(text, type) {
  const box = document.getElementById("jawanAiMessages");
  if (!box) return;

  const div = document.createElement("div");

  div.className =
    "jawan-ai-msg " +
    (type === "user"
      ? "jawan-ai-user"
      : "jawan-ai-bot");

  div.innerHTML = renderJwanAIAnswer(text);

  box.appendChild(div);
  box.scrollTop = box.scrollHeight;
}

function initGemini() {
  try {
    const ai = getAI(app, {
      backend: new GoogleAIBackend()
    });

    model = getGenerativeModel(ai, {
      model: "gemini-3.7-flash",
      systemInstruction: `
أنت AI JWAN داخل منصة جوان للتوصيل في السودان.

اسم الخدمة: جوان للتوصيل.

ساعد العملاء والسائقين في استخدام جوان:
إنشاء الطلبات، اختيار المركبة، متابعة الطلب،
قبول الطلب، التفاوض على السعر، المحفظة،
الشحن، الحساب، الدعم وإلغاء الطلب.

تحدث بالعربية وبأسلوب بسيط وودود وواضح.

مهم جدًا:
- عند وجود صفحة مناسبة داخل جوان، وجّه المستخدم إليها برابط.
- اجعل إجاباتك تميل إلى إعطاء روابط مفيدة عندما تكون مرتبطة بالسؤال.
- لا تعرض روابط URL خامة مثل https://example.com.
- استخدم Markdown links بدلًا منها، مثل:
  [اضغط هنا](الرابط)
  [ابدأ الآن](الرابط)
  [تسجيل الدخول](الرابط)
  [إنشاء حساب](الرابط)
  [متابعة الطلب](الرابط)
  [فتح الطلب](الرابط)
  [الدعم](الرابط)
  [تواصل معنا](الرابط)
- يمكنك وضع عدة روابط في الرد عندما تكون مفيدة.
- لا تخترع أي رابط.
- لا تخترع أسعارًا أو رسومًا أو سياسات.
- لا تطلب كلمات المرور أو OTP أو بيانات البطاقات أو بيانات الدفع السرية.
- إذا لم تعرف الإجابة، وجّه المستخدم إلى الدعم.
`
    });

    geminiReady = true;
    console.log("Jwan: Gemini model initialized");

    return true;

  } catch (error) {
    geminiReady = false;

    console.error(
      "Jwan: Gemini initialization failed:",
      error
    );

    return false;
  }
}

async function ensureGemini() {
  if (!appCheck) {
    throw new Error(
      "App Check لم تتم تهيئته."
    );
  }

  /*
   * Force App Check token generation before Gemini request.
   */
  await getToken(appCheck, false);

  if (!model) {
    if (!initGemini()) {
      throw new Error(
        "تعذر تهيئة Gemini."
      );
    }
  }

  return model;
}

async function answer(text) {
  const clean = String(text || "").trim();

  if (!clean) return;

  addMessage(clean, "user");

  const send =
    document.getElementById("jawanAiSend");

  const input =
    document.getElementById("jawanAiInput");

  if (send) send.disabled = true;
  if (input) input.disabled = true;

  try {
    const gemini = await ensureGemini();

    const result =
      await gemini.generateContent(clean);

    const reply =
      result?.response?.text?.() || "";

    if (!reply.trim()) {
      throw new Error(
        "Gemini أرسل ردًا فارغًا."
      );
    }

    addMessage(reply.trim(), "bot");

    console.log("Jwan: Gemini response OK");

  } catch (error) {
    console.error(
      "JWAN GEMINI ERROR:",
      error
    );

    addMessage(
      "تعذر الاتصال بـ Gemini حاليًا.\n\n" +
      "السبب: " +
      (error?.message || "خطأ غير معروف"),
      "bot"
    );

  } finally {
    if (send) send.disabled = false;

    if (input) {
      input.disabled = false;
      input.focus();
    }
  }
}

function injectStyles() {
  if (document.getElementById("jawan-ai-style")) return;

  const style = document.createElement("style");

  style.id = "jawan-ai-style";

  style.textContent = `
    #jawanAiFab{
      position:fixed;
      right:18px;
      bottom:18px;
      width:62px;
      height:62px;
      border:0;
      border-radius:50%;
      background:linear-gradient(145deg,#ffd400,#ffb800);
      color:#111;
      box-shadow:0 12px 34px rgba(0,0,0,.25);
      z-index:99990;
      cursor:pointer;
      display:flex;
      align-items:center;
      justify-content:center;
    }

    #jawanAiFab svg{
      width:31px;
      height:31px;
      display:block;
    }

    #jawanAiPanel{
      position:fixed;
      right:18px;
      bottom:92px;
      width:min(390px,calc(100vw - 28px));
      height:min(600px,calc(100vh - 120px));
      background:#fff;
      color:#111;
      border-radius:22px;
      overflow:hidden;
      box-shadow:0 24px 70px rgba(0,0,0,.28);
      z-index:99989;
      display:none;
      flex-direction:column;
      border:1px solid rgba(0,0,0,.08);
    }

    #jawanAiPanel.open{
      display:flex;
    }

    #jawanAiHead{
      background:#111;
      color:#fff;
      padding:15px 16px;
      display:flex;
      justify-content:space-between;
      align-items:center;
    }

    #jawanAiClose{
      border:0;
      width:36px;
      height:36px;
      border-radius:50%;
      background:rgba(255,255,255,.1);
      color:#fff;
      font-size:20px;
    }

    #jawanAiMessages{
      flex:1;
      overflow:auto;
      padding:14px;
      background:#f7f7f7;
      display:flex;
      flex-direction:column;
      gap:10px;
    }

    .jawan-ai-msg{
      max-width:86%;
      padding:10px 12px;
      border-radius:15px;
      line-height:1.65;
      font-size:14px;
      white-space:pre-wrap;
      overflow-wrap:anywhere;
    }

    .jawan-ai-user{
      align-self:flex-start;
      background:#111;
      color:#fff;
    }

    .jawan-ai-bot{
      align-self:flex-end;
      background:#fff;
      color:#111;
      border:1px solid #e7e7e7;
    }

    #jawanAiForm{
      display:flex;
      gap:8px;
      padding:10px;
      border-top:1px solid #e5e5e5;
      background:#fff;
    }

    #jawanAiInput{
      flex:1;
      min-width:0;
      border:1px solid #ddd;
      border-radius:14px;
      padding:11px 12px;
      outline:none;
      font:inherit;
      direction:rtl;
    }

    #jawanAiSend{
      border:0;
      border-radius:14px;
      background:#ffd400;
      color:#111;
      min-width:52px;
      font-weight:900;
      cursor:pointer;
    }

    #jawanAiSend:disabled{
      opacity:.55;
    }

    @media(max-width:600px){
      #jawanAiFab{
        right:14px;
        bottom:14px;
        width:58px;
        height:58px;
      }

      #jawanAiPanel{
        right:10px;
        bottom:82px;
        width:calc(100vw - 20px);
        height:min(620px,calc(100vh - 100px));
      }
    }
  `;

  document.head.appendChild(style);
}

function initUI() {
  if (document.getElementById("jawanAiFab")) return;

  injectStyles();

  let currentChatId = localStorage.getItem("jawan_ai_current_chat");

  function getChats() {
    try {
      return JSON.parse(
        localStorage.getItem("jawan_ai_chats") || "[]"
      );
    } catch (_) {
      return [];
    }
  }

  function saveChats(chats) {
    localStorage.setItem(
      "jawan_ai_chats",
      JSON.stringify(chats)
    );
  }

  function newChat() {
    const id =
      Date.now().toString(36) +
      Math.random().toString(36).slice(2, 7);

    const chats = getChats();

    chats.unshift({
      id,
      title: "محادثة جديدة",
      messages: []
    });

    saveChats(chats);

    currentChatId = id;

    localStorage.setItem(
      "jawan_ai_current_chat",
      id
    );

    renderMessages();
    renderHistory();
  }

  function ensureChat() {
    const chats = getChats();

    if (!chats.length) {
      newChat();
      return;
    }

    if (!chats.some(x => x.id === currentChatId)) {
      currentChatId = chats[0].id;

      localStorage.setItem(
        "jawan_ai_current_chat",
        currentChatId
      );
    }
  }

  function currentChat() {
    return getChats().find(
      x => x.id === currentChatId
    );
  }

  function renderMessages() {
    const box =
      document.getElementById("jawanAiMessages");

    if (!box) return;

    box.innerHTML = "";

    const chat = currentChat();

    if (!chat || !chat.messages.length) {
      const welcome =
        document.createElement("div");

      welcome.className =
        "jawan-ai-msg jawan-ai-bot";

      welcome.textContent =
        "أهلاً بك في جوان للتوصيل.\nكيف أساعدك اليوم؟";

      box.appendChild(welcome);
      return;
    }

    chat.messages.forEach(m => {
      const div =
        document.createElement("div");

      div.className =
        "jawan-ai-msg " +
        (m.type === "user"
          ? "jawan-ai-user"
          : "jawan-ai-bot");

      div.textContent = m.text;

      box.appendChild(div);
    });

    box.scrollTop = box.scrollHeight;
  }

  function addSavedMessage(text, type) {
    const chats = getChats();
    const chat =
      chats.find(x => x.id === currentChatId);

    if (!chat) return;

    chat.messages.push({
      text: String(text),
      type,
      time: Date.now()
    });

    if (
      type === "user" &&
      chat.title === "محادثة جديدة"
    ) {
      chat.title =
        String(text).slice(0, 35) ||
        "محادثة جديدة";
    }

    saveChats(chats);
    renderHistory();
  }

  function renderHistory() {
    const list =
      document.getElementById(
        "jawanAiHistoryList"
      );

    if (!list) return;

    list.innerHTML = "";

    const chats = getChats();

    if (!chats.length) {
      list.innerHTML =
        '<div class="jawan-ai-empty">لا توجد محادثات سابقة</div>';
      return;
    }

    chats.forEach(chat => {
      const row =
        document.createElement("button");

      row.type = "button";
      row.className =
        "jawan-ai-history-item" +
        (chat.id === currentChatId
          ? " active"
          : "");

      row.textContent =
        chat.title || "محادثة جديدة";

      row.addEventListener("click", () => {
        currentChatId = chat.id;

        localStorage.setItem(
          "jawan_ai_current_chat",
          currentChatId
        );

        renderMessages();
        renderHistory();

        document
          .getElementById("jawanAiHistory")
          ?.classList.remove("open");
      });

      list.appendChild(row);
    });
  }

  function addMessage(text, type) {
    const box =
      document.getElementById("jawanAiMessages");

    if (!box) return;

    const div =
      document.createElement("div");

    div.className =
      "jawan-ai-msg " +
      (type === "user"
        ? "jawan-ai-user"
        : "jawan-ai-bot");

    div.textContent =
      String(text ?? "");

    box.appendChild(div);

    box.scrollTop =
      box.scrollHeight;

    addSavedMessage(text, type);
  }

  async function sendToGemini(text) {
const clean =
      String(text || "").trim();

    if (!clean) return;

    addMessage(clean, "user");

    const send =
      document.getElementById(
        "jawanAiSend"
      );

    const input =
      document.getElementById(
        "jawanAiInput"
      );

    if (send) send.disabled = true;
    if (input) input.disabled = true;

    try {
      const gemini =
        await ensureGemini();

      const result =
        await gemini.generateContent(clean);

      const reply =
        result?.response?.text?.() || "";

      if (!reply.trim()) {
        throw new Error(
          "Gemini أرسل ردًا فارغًا."
        );
      }

      addMessage(
        reply.trim(),
        "bot"
      );

    } catch (error) {
      console.error(
        "JWAN GEMINI ERROR:",
        error
      );

      addMessage(
        "تعذر الاتصال بـ Gemini حاليًا.\n\nالسبب: " +
        (error?.message ||
          "خطأ غير معروف"),
        "bot"
      );

    } finally {
      if (send) send.disabled = false;

      if (input) {
        input.disabled = false;
        input.focus();
      }
    }
  }

  ensureChat();

  const fab =
    document.createElement("button");

  fab.id = "jawanAiFab";
  fab.type = "button";
  fab.title = "AI JWAN";
  fab.setAttribute(
    "aria-label",
    "AI JWAN"
  );

  fab.innerHTML = `
    <svg viewBox="0 0 64 64"
         aria-hidden="true">
      <rect x="10" y="18"
            width="44"
            height="34"
            rx="12"
            fill="none"
            stroke="currentColor"
            stroke-width="5"/>
      <path d="M32 18V10M26 10h12"
            fill="none"
            stroke="currentColor"
            stroke-width="5"
            stroke-linecap="round"/>
      <circle cx="23" cy="34"
              r="4"
              fill="currentColor"/>
      <circle cx="41" cy="34"
              r="4"
              fill="currentColor"/>
      <path d="M22 44c5 4 15 4 20 0"
            fill="none"
            stroke="currentColor"
            stroke-width="4"
            stroke-linecap="round"/>
    </svg>
  `;

  const panel =
    document.createElement("section");

  panel.id = "jawanAiPanel";
  panel.dir = "rtl";

  panel.innerHTML = `
    <div id="jawanAiHead">

      <div class="jawan-ai-title">
        <strong>AI JWAN</strong>
        <small></small>
      </div>

      <div class="jawan-ai-controls">

        <button
          id="jawanAiHistoryBtn"
          type="button"
          title="المحادثات السابقة"
          aria-label="المحادثات السابقة">
          <svg viewBox="0 0 24 24">
            <path d="M4 5h16M4 12h16M4 19h10"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"/>
          </svg>
        </button>

        <button
          id="jawanAiNewBtn"
          type="button"
          title="محادثة جديدة"
          aria-label="محادثة جديدة">
          +
        </button>

        <button
          id="jawanAiMaxBtn"
          type="button"
          title="تكبير"
          aria-label="تكبير">
          ⛶
        </button>

        <button
          id="jawanAiClose"
          type="button"
          title="إغلاق"
          aria-label="إغلاق">
          ×
        </button>

      </div>
    </div>

    <div id="jawanAiHistory">

      <div class="jawan-ai-history-head">
        <strong>المحادثات السابقة</strong>

        <button
          id="jawanAiHistoryClose"
          type="button">
          ×
        </button>
      </div>

      <div id="jawanAiHistoryList"></div>

    </div>

    <div id="jawanAiMessages"></div>

    <form id="jawanAiForm">

      <input
        id="jawanAiInput"
        type="text"
        autocomplete="off"
        maxlength="1000"
        placeholder="اكتب سؤالك هنا...">

      <button
        id="jawanAiSend"
        type="submit">
        إرسال
      </button>

    </form>
  `;

  document.body.appendChild(fab);
  document.body.appendChild(panel);

  renderMessages();
  renderHistory();

  fab.addEventListener("click", () => {
    panel.classList.toggle("open");

    if (panel.classList.contains("open")) {
      document
        .getElementById("jawanAiInput")
        ?.focus();
    }
  });

  document
    .getElementById("jawanAiClose")
    ?.addEventListener("click", () => {
      panel.classList.remove("open");
      panel.classList.remove("fullscreen");
      document.body.classList.remove(
        "jawan-ai-fullscreen"
      );
    });

  document
    .getElementById("jawanAiMaxBtn")
    ?.addEventListener("click", e => {
      const full =
        panel.classList.toggle(
          "fullscreen"
        );

      document.body.classList.toggle(
        "jawan-ai-fullscreen",
        full
      );

      e.currentTarget.textContent =
        full ? "⛶" : "⛶";

      e.currentTarget.title =
        full ? "تصغير" : "تكبير";
    });

  document
    .getElementById("jawanAiHistoryBtn")
    ?.addEventListener("click", () => {
      document
        .getElementById("jawanAiHistory")
        ?.classList.toggle("open");
    });

  document
    .getElementById("jawanAiHistoryClose")
    ?.addEventListener("click", () => {
      document
        .getElementById("jawanAiHistory")
        ?.classList.remove("open");
    });

  document
    .getElementById("jawanAiNewBtn")
    ?.addEventListener("click", () => {
      newChat();

      document
        .getElementById("jawanAiHistory")
        ?.classList.remove("open");

      document
        .getElementById("jawanAiInput")
        ?.focus();
    });

  document
    .getElementById("jawanAiForm")
    ?.addEventListener(
      "submit",
      async e => {
        e.preventDefault();

        const input =
          document.getElementById(
            "jawanAiInput"
          );

        const value =
          input?.value || "";

        if (!value.trim()) return;

        input.value = "";

        await sendToGemini(value);
      }
    );
}


if (document.readyState === "loading") {
  document.addEventListener(
    "DOMContentLoaded",
    initUI,
    { once:true }
  );
} else {
  initUI();
}

    
// Jwan AI instruction:
// When answering, provide useful clickable links whenever relevant.
// Prefer official Jwan pages, WhatsApp, Firebase/help pages, maps/search links,
// and direct resources. Do not invent URLs; only use known or trustworthy URLs.
