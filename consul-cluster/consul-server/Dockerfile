FROM pgentile/consul

ENTRYPOINT ["consul", "agent", "-config-dir", "/etc/consul.d", "-server"]
CMD ["-bootstrap-expect=1"]
