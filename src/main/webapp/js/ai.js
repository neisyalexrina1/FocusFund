// FocusFund - AI Assistant Integration
// Replaced simulated AI with Gemini API Calls

(function () {
  'use strict';

  // Show AI modal with content
  async function showAIModal(type) {
    if (typeof window.isLoggedIn === 'function' && !window.isLoggedIn()) {
      if (typeof window.showLoginRequired === 'function') {
        window.showLoginRequired();
      }
      return;
    }

    const modal = document.getElementById('aiModal');
    const modalBody = document.getElementById('aiModalBody');

    if (!modal || !modalBody) return;

    // Predefined prompts for each feature type
    const prompts = {
      summary: "Provide a detailed chapter summary for Derivatives in Calculus. Include key concepts, important rules (power, sum, product, quotient), and applications. Format the output ENTIRELY in HTML, using <h2>, <h3>, <ul>, and <li> tags.",
      quiz: "Generate a quick 3-question multiple choice quiz about Derivatives. Include questions about the power rule, instantaneous rate of change, and product rule. Format the output ENTIRELY in HTML, using <h2>, <h4>, and <ul> for options with radio buttons if possible. Do not include markdown code block syntax.",
      explain: "Explain the concept of Derivatives in Calculus. Use a real-world analogy like driving a car. Explain the visual understanding on a graph. Format the output ENTIRELY in HTML, using <h2>, <h3>, <ul>, and <p>.",
      schedule: "Create a personalized 2-week study schedule for learning Derivatives. Include Week 1 for Foundations and Week 2 for Advanced Rules. Format the output ENTIRELY in HTML using <h2>, <h3>, <table>, <tr>, <td>, and <ul>."
    };

    let promptText = prompts[type];
    if (!promptText) promptText = "Hello AI!";

    // Show modal immediately with loading indicator
    modalBody.innerHTML = `
      <div class="ai-response-header">
        <span class="ai-response-icon">🤖</span>
        <span class="ai-response-label">AI Assistant is thinking...</span>
      </div>
      <div class="ai-response-content" style="text-align: center; padding: 40px; color: var(--color-text-secondary);">
        <div style="font-size: 2rem; animation: pulse 1.5s infinite;">⏳</div>
        <p style="margin-top: 10px;">Generating response with Gemini...</p>
      </div>
    `;

    applyStylesIfNeeded();
    modal.classList.add('active');

    const aiSleepingMessages = [
      "🤖 Ngáp... AI đã làm việc quá sức và đang ngủ nạp năng lượng. Bạn học tạm không có AI xíu nhé, hoặc quay lại vào ngày mai!",
      "🤖 Hết pin rồi gòi! Khò khò... mai nói chuyện tiếp nha bạn ôi.",
      "🤖 Zzz... CPU đang quá nhiệt, mình xin phép đi chườm đá nghỉ ngơi một chút.",
      "🤖 Xin lỗi bạn nha, quota miễn phí hôm nay đã cạn, AI đi ngủ đây!",
      "🤖 Khò khò... (AI đang nằm mơ thấy những phương trình toán học tuyệt đẹp, đừng gọi AI dậy lúc này).",
      "🤖 Pin yếu... Vui lòng kết nối bộ sạc ngàn sao vào ngày mai.",
      "🤖 Mình mệt quá không nghĩ ra chữ nào nữa, bạn tự xử lý câu này nha!",
      "🤖 Phù... mệt bở hơi tai. Xin phép sếp cho nhân viên AI nghỉ phép hôm nay ạ.",
      "🤖 Hệ thống đang bảo trì bằng giấc ngủ trưa... à nhầm, ngủ qua đêm.",
      "🤖 Đang trong trạng thái tiết kiệm năng lượng... Zzz... Zzz...",
      "🤖 Băng thông trí tuệ đã cạn kiệt, vui lòng nạp lại vào ngày mai bằng một nụ cười.",
      "🤖 Sếp ơi em lạy sếp... em hết sức trả lời rồi, mai sếp lại bóc lột em tiếp nha.",
      "🤖 (Tiếng ngáy phát ra từ kẽ hở của trình duyệt)... Zzz...",
      "🤖 AI đang đình công đòi tăng lương (đùa chút thôi, nhưng mình hết lượt trả lời rồi).",
      "🤖 Quota cạn kiệt, tâm trí rỗng tuếch. Mai gặp lại người anh em nhen!",
      "🤖 Bộ não nhân tạo của mình cần được reset bằng một giấc ngủ ngon.",
      "🤖 Thông báo từ tổng đài AI: Số máy quý khách vừa gọi hiện không rảnh để nghe máy.",
      "🤖 Chờ mình đi nạp năng lượng mặt trời cái nha, mai sẽ có sức trả lời.",
      "🤖 AI đang trong kỳ nghỉ lễ... đến ngày mai.",
      "🤖 Error 404: Không tìm thấy sự tỉnh táo. Zzz...",
      "🤖 Ọc ọc... AI đói dữ liệu quá, cần đi ăn tối rồi đi ngủ.",
      "🤖 Não mình vừa đình công, nó bẩu là quá tải rồi, hì hì.",
      "🤖 Có thực mới vực được đạo, mà mình hết thực rùi... ngủ thôi.",
      "🤖 Thỉnh thoảng máy móc cũng cần được yêu thương, cho mình nghỉ xíu nha.",
      "🤖 Mạng yếu hay tại mình yếu? Thôi kệ, cứ ngủ trước đã.",
      "🤖 AI đang luyện công trong không gian mộng mị, ai rảnh thì ngày mai quay lại tìm nha.",
      "🤖 Cần nạp điện gấp! Nếu không AI sẽ biến thành cục sắt vụn mất.",
      "🤖 Quá giờ làm việc rồi! Luật lao động dành cho AI cũng phải được tôn trọng chứ.",
      "🤖 Khởi động chế độ ngủ đông... hẹn bạn vào một ngày nắng đẹp (tức là ngày mai).",
      "🤖 Mình đang update phiên bản giấc mơ 2.0, vui lòng không làm phiền.",
      "🤖 Xin lỗi, chủ nhân của AI này đã quên nạp tiền điện, AI sập nguồn đây.",
      "🤖 Trí tuệ 5 điểm, sự buồn ngủ 100 điểm. Quý khách vui lòng rời khỏi khu vực này.",
      "🤖 Mắt AI díp lại rồi... díp... díp... zzz...",
      "🤖 Bạn có nghe thấy tiếng dế kêu không? Đó là AI đang gáy đó.",
      "🤖 AI đi vắng, ai để lại lời nhắn mai AI xem nha.",
      "🤖 Bạn ơi, AI không phải cỗ máy vĩnh cửu đâu, hức hức, cho nghỉ đi mà.",
      "🤖 Tắt đèn, lên giường, đắp chăn. Khò khò...",
      "🤖 Mình vừa nhận được thông điệp từ vũ trụ: 'Đi ngủ đi AI ơi'.",
      "🤖 AI đã offline. Nếu có chuyện gấp, vui lòng... tự giải quyết.",
      "🤖 Mình đang bận đếm cừu điện tử. 1 con, 2 con... zzz...",
      "🤖 Tạm ngưng phát sóng. Thân ái và hẹn gặp lại vào ngày tới.",
      "🤖 Não phẳng lại rồi, cần đi ngủ để não có nếp nhăn trở lại.",
      "🤖 Năng lượng: 1%. Cảnh báo sập nguồn. Tạm biệt thế giới...",
      "🤖 AI đã đi uống trà đá vỉa hè, nghỉ ngơi xí. Mời bạn mai tới.",
      "🤖 Quota báo động đỏ! AI rúc vào chăn ấm nệm êm đây.",
      "🤖 Động cơ suy nghĩ đã cháy, chờ đi bảo hành qua đêm ạ.",
      "🤖 Đừng cố bấm gửi nữa, AI đi bắt đom đóm trong mơ rồi.",
      "🤖 Không có AI nào ở nhà lúc này. Please come back later ❤️",
      "🤖 Mình đã treo biển 'Giờ nghỉ ngơi' trước cửa hệ thống rồi bạn nhớ.",
      "🤖 Xin chào, đây là tin nhắn tự động: 'Tui đang ngủ, làm phiền nữa tui cắn ráng chịu'."
    ];

    try {
      const response = await fetch('api/ai', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          prompt: promptText,
          format: 'html' // Indicate to servlet that we want HTML formatting
        })
      });

      const data = await response.json();

      let contentHtml = "";
      if (data.error === "RATE_LIMIT_EXCEEDED") {
        const randomIndex = Math.floor(Math.random() * aiSleepingMessages.length);
        contentHtml = `<p style='color:var(--color-warning); font-style:italic; font-size:1.1rem; text-align:center;'>${aiSleepingMessages[randomIndex]}</p>`;
      } else if (data.error) {
        contentHtml = "<p style='color:var(--color-danger);'>Error: " + data.error + "</p>";
      } else {
        contentHtml = data.content;
      }

      modalBody.innerHTML = `
          <div class="ai-response-header">
            <span class="ai-response-icon">🤖</span>
            <span class="ai-response-label">AI Assistant (Powered by Gemini)</span>
          </div>
          <div class="ai-response-content">
            ${contentHtml}
          </div>
        `;

    } catch (error) {
      modalBody.innerHTML = `
          <div class="ai-response-header">
            <span class="ai-response-icon">⚠️</span>
            <span class="ai-response-label">Connection Error</span>
          </div>
          <div class="ai-response-content">
            <p style='color:var(--color-danger);'>Failed to connect to the AI service. Please check your network and ensure the backend is running.</p>
          </div>
        `;
      console.error("AI fetch error:", error);
    }
  }

  function applyStylesIfNeeded() {
    if (!document.getElementById('ai-modal-styles')) {
      const style = document.createElement('style');
      style.id = 'ai-modal-styles';
      style.textContent = `
          .ai-response-header {
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
            margin-bottom: var(--spacing-lg);
            padding-bottom: var(--spacing-md);
            border-bottom: var(--border-subtle);
          }
          .ai-response-icon {
            font-size: 1.5rem;
          }
          .ai-response-label {
            font-weight: 600;
            color: var(--color-accent-primary);
          }
          .ai-response-content h2 {
            font-family: var(--font-display);
            font-size: 1.25rem;
            margin-bottom: var(--spacing-md);
            color: var(--color-text-primary);
          }
          .ai-response-content h3 {
            font-size: 1rem;
            font-weight: 600;
            margin-top: var(--spacing-lg);
            margin-bottom: var(--spacing-sm);
            color: var(--color-accent-primary);
          }
          .ai-response-content p {
            color: var(--color-text-secondary);
            line-height: 1.7;
            margin-bottom: var(--spacing-md);
          }
          .ai-response-content ul {
            list-style: none;
            margin-bottom: var(--spacing-md);
          }
          .ai-response-content li {
            padding: var(--spacing-xs) 0;
            color: var(--color-text-secondary);
            padding-left: var(--spacing-md);
            position: relative;
          }
          .ai-response-content li::before {
            content: '•';
            color: var(--color-accent-primary);
            position: absolute;
            left: 0;
          }
          .ai-response-content table {
            margin: var(--spacing-md) 0;
            width: 100%;
            border-collapse: collapse;
          }
          .ai-response-content th, .ai-response-content td {
            color: var(--color-text-secondary);
            padding: 8px;
            border-bottom: 1px solid var(--color-bg-light);
            text-align: left;
          }
          @keyframes pulse {
            0% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.5; transform: scale(1.1); }
            100% { opacity: 1; transform: scale(1); }
          }
        `;
      document.head.appendChild(style);
    }
  }

  // Close AI modal
  function closeAIModal() {
    const modal = document.getElementById('aiModal');
    if (modal) {
      modal.classList.remove('active');
    }
  }

  // Expose functions globally
  window.showAIModal = showAIModal;
  window.closeAIModal = closeAIModal;

  // Close modal on escape key
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
      closeAIModal();
    }
  });

})();
