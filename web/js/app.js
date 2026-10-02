// ============================================================
// SkillSwap Campus - Main JavaScript
// ============================================================

document.addEventListener('DOMContentLoaded', () => {

    // ── Password show / hide (all password fields) ──
    const initPasswordToggles = () => {
        document.querySelectorAll('input[type="password"]').forEach(input => {
            if (input.closest('.password-field-wrap')) return;
            const wrap = document.createElement('div');
            wrap.className = 'password-field-wrap';
            input.parentNode.insertBefore(wrap, input);
            wrap.appendChild(input);
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'pwd-toggle';
            btn.setAttribute('aria-label', 'Show password');
            btn.innerHTML = '<i class="fa-regular fa-eye"></i>';
            btn.addEventListener('click', () => {
                const show = input.type === 'password';
                input.type = show ? 'text' : 'password';
                btn.innerHTML = show ? '<i class="fa-regular fa-eye-slash"></i>' : '<i class="fa-regular fa-eye"></i>';
                btn.setAttribute('aria-label', show ? 'Hide password' : 'Show password');
            });
            wrap.appendChild(btn);
        });
    };
    initPasswordToggles();

    // ── Login: keep fields blank (clear browser autofill on load) ──
    const loginEmail = document.getElementById('loginEmail');
    const loginPassword = document.getElementById('loginPassword');
    if (loginEmail && loginPassword) {
        loginEmail.value = '';
        loginPassword.value = '';
        setTimeout(() => {
            loginEmail.value = '';
            loginPassword.value = '';
        }, 100);
    }

    // ── Sidebar Toggle ──
    const btnToggle = document.getElementById('sidebarToggle');
    const sidebar   = document.querySelector('.sidebar');
    if (btnToggle && sidebar) {
        btnToggle.addEventListener('click', () => {
            sidebar.classList.toggle('open');
        });
    }

    // ── Tabs ──
    const tabBtns = document.querySelectorAll('.tab-btn');
    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            // Remove active from all tabs in same group
            const group = btn.closest('.card-body') || document;
            group.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            group.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));

            // Add active to clicked
            btn.classList.add('active');
            const target = document.getElementById(btn.dataset.target);
            if (target) target.classList.add('active');
        });
    });

    // ── Modal ──
    window.openModal = (id) => {
        const modal = document.getElementById(id);
        if (modal) modal.classList.add('open');
    }
    window.closeModal = (id) => {
        const modal = document.getElementById(id);
        if (modal) modal.classList.remove('open');
    }

    const closeBtns = document.querySelectorAll('.modal-close');
    closeBtns.forEach(btn => {
        btn.addEventListener('click', (e) => {
            const m = e.target.closest('.modal-overlay');
            if (m) m.classList.remove('open');
        });
    });

    // Close on overlay click
    const overlays = document.querySelectorAll('.modal-overlay');
    overlays.forEach(overlay => {
        overlay.addEventListener('click', (e) => {
            if (e.target === overlay) overlay.classList.remove('open');
        });
    });

    // ── Chat Functionality (WhatsApp style) ──
    const chatContainer = document.getElementById('chatMessages');
    const chatForm      = document.getElementById('chatForm');
    const msgInput      = document.getElementById('msgInput');
    const currentReceiverId = document.getElementById('currentReceiverId');

    // Auto-scroll chat to bottom
    const scrollToBottom = () => {
        if (chatContainer) chatContainer.scrollTop = chatContainer.scrollHeight;
    };

    // Load messages via AJAX
    const loadMessages = () => {
        if (!chatContainer || !currentReceiverId || !currentReceiverId.value) return;
        const rid = currentReceiverId.value;

        fetch(`chat?action=getMessages&receiverId=${rid}`)
            .then(res => res.json())
            .then(data => {
                chatContainer.innerHTML = '';
                if (data.length === 0) {
                    chatContainer.innerHTML = `
                        <div class="chat-empty">
                            <div class="chat-empty-icon">👋</div>
                            <h3>Say Hello!</h3>
                            <p>No messages yet. Start the conversation.</p>
                        </div>
                    `;
                    return;
                }
                const myId = document.body.dataset.userid;
                data.forEach(m => {
                    const isMe = m.senderId == myId;
                    const rowClass = isMe ? 'sent' : 'received';
                    const time = m.sentTime ? m.sentTime.substring(11, 16) : '';
                    chatContainer.innerHTML += `
                        <div class="msg-row ${rowClass}">
                            <div class="msg-bubble ${rowClass}">
                                ${m.message.replace(/\n/g, '<br>')}
                                <div class="msg-time ${isMe?'':'received-time'}">${time}</div>
                            </div>
                        </div>
                    `;
                });
                scrollToBottom();
            })
            .catch(err => console.error("Error loading messages:", err));
    };

    // Send message via AJAX
    if (chatForm) {
        chatForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const text = msgInput.value.trim();
            if (!text || !currentReceiverId.value) return;

            const formData = new URLSearchParams();
            formData.append('receiverId', currentReceiverId.value);
            formData.append('message', text);

            fetch('chat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    msgInput.value = '';
                    loadMessages();
                } else {
                    alert('Failed to send message.');
                }
            })
            .catch(err => console.error("Error sending message:", err));
        });
    }

    // Initial load and polling
    if (chatContainer && currentReceiverId && currentReceiverId.value) {
        loadMessages();
        setInterval(loadMessages, 3000); // Poll every 3 seconds for WhatsApp-like feel
    }

    // New Chat selection trigger
    const newChatSelect = document.getElementById('newChatSelect');
    if (newChatSelect) {
        newChatSelect.addEventListener('change', function() {
            if (this.value) {
                window.location.href = 'chat?with=' + this.value;
            }
        });
    }

    // Mobile Chat contacts toggle
    const btnBackContacts = document.getElementById('btnBackContacts');
    const chatContactsPane = document.querySelector('.chat-contacts');
    if (btnBackContacts && chatContactsPane) {
        btnBackContacts.addEventListener('click', () => {
            chatContactsPane.classList.toggle('mobile-show');
        });
    }

    // Auto dismiss alerts after 5 seconds
    setTimeout(() => {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(a => {
            a.style.opacity = '0';
            setTimeout(() => a.remove(), 300);
        });
    }, 5000);

});
