from reportlab.lib.pagesizes import LETTER
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch

out = "Dozzle_Guide.pdf"
styles = getSampleStyleSheet()
body = styles["BodyText"]; title = styles["Title"]; h2 = styles["Heading2"]
doc = SimpleDocTemplate(out, pagesize=LETTER, leftMargin=0.8*inch, rightMargin=0.8*inch, topMargin=0.8*inch, bottomMargin=0.8*inch)
S = []
S += [Paragraph("Dozzle – Homelab Guide", title), Spacer(1,0.25*inch)]
S += [Paragraph("Purpose: Real-time Docker container logs in the browser; lightweight alternative to Loki/Promtail.", body), Spacer(1,0.1*inch)]
S += [Paragraph("URL: http://$NODE_IP:8888", body), Spacer(1,0.2*inch)]
S += [Paragraph("Placement", h2), Paragraph("- Stack: stacks/monitoring<br/>- Compose: stacks/monitoring/dozzle.yml (service) + stacks/monitoring/ports.override.yml (8888:8080)<br/>- Network: core (external)", body), Spacer(1,0.2*inch)]
S += [Paragraph("Homepage Integration", h2), Paragraph("File: stacks/homepage/config/services.yaml → under the Monitoring group add:", body),
      Paragraph("<font name='Courier'>    - Dozzle:<br/>        href: http://$NODE_IP:8888<br/>        description: Live container logs<br/>        status: http://$NODE_IP:8888<br/>        target: _blank</font>", body), Spacer(1,0.2*inch)]
S += [Paragraph("Restore", h2), Paragraph("Script: ops/restore_dozzle.sh<br/>Usage: bash ~/homelab/ops/restore_dozzle.sh", body), Spacer(1,0.2*inch)]
S += [Paragraph("Verification / Health", h2), Paragraph("docker ps --filter name=dozzle<br/>curl -s -o /dev/null -w \"%{http_code}\" http://$NODE_IP:8888  → expect 200", body), Spacer(1,0.2*inch)]
S += [Paragraph("Notes", h2), Paragraph("- Uses /var/run/docker.sock (read-only).<br/>- No secrets required.<br/>- Restart policy: unless-stopped.", body)]
doc.build(S)
print(f"Wrote {out}")
