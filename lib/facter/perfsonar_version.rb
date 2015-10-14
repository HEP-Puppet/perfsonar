Facter.add(:perfsonar_version) do
  confine :osfamily => 'RedHat'
  setcode do
    perfsonar = Facter::Util::Resolution::exec('/bin/rpm -q --qf "%{NAME} %{VERSION}\n" perl-perfSONAR_PS-Toolkit | grep "^perl-perfSONAR_PS-Toolkit "')
    perfsonar.split(/ /)[1] if perfsonar
  end
end
