<%@ page contentType="text/html; charset=UTF-8" %>
<section style="background: #ffffff; padding: 20px 0 100px 0;">
    <div class="container">
        <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 24px; padding: 60px 40px; color: white; text-align: center; box-shadow: 0 20px 40px rgba(102, 126, 234, 0.25);">
            <h2 style="font-size: 32px; margin-bottom: 50px; font-weight: 800;">Our Impact in Numbers</h2>

            <div style="display: flex; flex-wrap: wrap; justify-content: space-around; gap: 40px;">
                <div>
                    <div style="font-size: 54px; font-weight: 900; margin-bottom: 10px;">${empty totalEvents ? '150+' : totalEvents}</div>
                    <div style="font-size: 15px; opacity: 0.9; text-transform: uppercase; letter-spacing: 2px; font-weight: 600;">Events Organized</div>
                </div>
                <div>
                    <div style="font-size: 54px; font-weight: 900; margin-bottom: 10px;">${empty totalOrgs ? '45+' : totalOrgs}</div>
                    <div style="font-size: 15px; opacity: 0.9; text-transform: uppercase; letter-spacing: 2px; font-weight: 600;">Active Organizations</div>
                </div>
                <div>
                    <div style="font-size: 54px; font-weight: 900; margin-bottom: 10px;">${empty totalVols ? '2,500+' : totalVols}</div>
                    <div style="font-size: 15px; opacity: 0.9; text-transform: uppercase; letter-spacing: 2px; font-weight: 600;">Passionate Volunteers</div>
                </div>
            </div>
        </div>
    </div>
</section>