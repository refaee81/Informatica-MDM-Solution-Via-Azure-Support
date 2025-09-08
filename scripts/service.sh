#!/bin/bash
cat << EOF > /etc/systemd/system/mdmagent.service 
    [Unit]
    Description=Informatica MDM Secure Agent
    After=syslog.target network.target

    [Service]
    Type=simple
    User=${adminuser}
    Group=${adminuser}
    ExecStart=/bin/bash -c '/home/${adminuser}/infaagent/apps/agentcore/infaagent startup'
    WorkingDirectory=/home/${adminuser}/infaagent/apps/agentcore
    Restart=always
    RestartSec=10

    [Install]
    WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start mdmagent.service
systemctl status mdmagent.service