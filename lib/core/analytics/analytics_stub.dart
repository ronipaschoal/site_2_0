/// Non-web platforms: Google Analytics is web-only, so every call is a no-op.
void loadGtag(String measurementId) {}

void sendGtagEvent(String name, Map<String, Object> params) {}
