using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public abstract class IEtfState
	{
		private EtfState etfState;
		public EtfState EtfState
		{
			get
			{
				return etfState;
			}
		}

		public bool Persist { get; set; }		

		public IEtfState( EtfState etfState )
		{
			this.etfState = etfState;
			this.Persist = false;
		}

		public abstract void Process( EtfContext context );

	}
}
