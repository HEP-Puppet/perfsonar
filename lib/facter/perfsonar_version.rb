Facter.add(:perfsonar_version) do
  confine :osfamily => 'RedHat'
  setcode do
    perfsonar = Facter::Util::Resolution::exec('/bin/rpm -q --qf "%{NAME} %{VERSION}\n" perfsonar-toolkit | grep "^perfsonar-toolkit "')
    perfsonar.split(/ /)[1] if perfsonar
  end
end
