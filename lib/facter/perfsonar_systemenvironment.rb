Facter.add(:perfsonar_systemenvironment) do
  confine :osfamily => 'RedHat'
  setcode do
    ps_se = Facter::Util::Resolution::exec('/bin/rpm -q --qf "%{NAME}\n" perl-perfSONAR_PS-Toolkit-SystemEnvironment | grep "^perl-perfSONAR_PS-Toolkit-SystemEnvironment$"')
    ps_se && !ps_se.empty? ? true : false
  end
end
